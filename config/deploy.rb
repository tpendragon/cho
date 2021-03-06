# frozen_string_literal: true

# lock '3.6'

# Set assets roles to occur on jobs as well as web
set :assets_role, %i[web job]

# application and repo settings
set :application, 'cho'
set :github_repo, 'cho-req'
set :repo_url, "https://github.com/psu-libraries/#{fetch(:github_repo)}.git"
set :branch, ENV['REVISION'] || ENV['BRANCH_NAME'] || 'master'

# default user and deployment location
set :user, 'deploy'
set :deploy_to, "/home/deploy/#{fetch(:application)}"
set :use_sudo, false

# ssh key settings
set :ssh_options, keys: [File.join(ENV['HOME'], '.ssh', 'id_deploy_rsa')],
                  forward_agent: true

# rbenv settings
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, File.read(File.join(File.dirname(__FILE__), '..', '.ruby-version')).chomp # read from file above
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec" # rbenv settings
set :rbenv_map_bins, %w(rake gem bundle ruby rails) # map the following bins
set :rbenv_roles, :all # default value

# set passenger to just the web servers
set :passenger_roles, :web

# rails settings, NOTE: Task is wired into event stack
set :rails_env, 'production'

# Settings for whenever gem that updates the crontab file on the server
# See schedule.rb for details
set :whenever_roles, %i[app job]

set :log_level, :debug
set :pty, true

# Airbrussh options
set :format_options, command_output: false

# Default value for :linked_files is []
# Example link: ln -s /opt/heracles/deploy/cho/shared/config/redis.yml /opt/heracles/deploy/cho/current/config/redis.yml
set :linked_files, fetch(:linked_files, []).push(
  'config/analytics.yml',
  'config/application.yml',
  'config/blacklight.yml',
  'config/database.yml',
  'config/fedora.yml',
  'config/ga-privatekey.p12',
  'config/hydra-ldap.yml',
  'config/newrelic.yml',
  'config/redis.yml',
  'config/role_map.yml',
  'config/secrets.yml',
  'config/solr.yml',
  'public/robots.txt'
)

set :linked_dirs, fetch(:linked_dirs, []).push(
  'log',
  'tmp/cache',
  'tmp/pids',
  'tmp/sockets',
  'tmp/uploads',
  'tmp/files',
  'vendor/bundle'
)

# Default value for keep_releases is 5
set :keep_releases, 7

# Default value for keep_releases is 5, setting to 7
set :keep_releases, 7

# Apache namespace to control apache
namespace :apache do
  %i[stop start restart reload].each do |action|
    desc "#{action.to_s.capitalize} Apache"
    task action do
      on roles(:web) do
        execute "sudo service httpd #{action}"
      end
    end
  end
end

namespace :deploy do
  desc 'set up the shared directory to have the symbolic links to the appropriate directories shared between servers'
  task :symlink_shared_directories do
    on roles(:web, :job) do
      execute "ln -sf /#{fetch(:application)}/config_#{fetch(:stage)}/cho/ /home/deploy/cho/shared/config"
    end
  end
  before 'deploy:check:linked_dirs', :symlink_shared_directories

  desc 'Compile assets on for selected server roles'
  task :roleassets do
    on roles(:job) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'assets:precompile '
        end
      end
    end
  end
  after :migrate, :roleassets

  # Passenger Capistrano Task
  # The passenger install task allows Chef to install Passenger now via Yum, but it allows Capistrano to maintain the file
  # as Ruby is updated on the system.  The PassengerDefaultRuby variable is set to system ruby by default from the Yum
  # install.  This will not work in our environment.
  # Passenger Install Task below defines the current ruby version
  # Adds it to temp file
  # then copies passenger configs to temp file.
  # Replaces all instances of PassengerRuby with proper version in temp file.
  # Replace passenger conf file with temp file.

  namespace :passenger do
    desc 'Passenger Version Config Update'
    task :config_update do
      on roles(:web) do
        execute 'mkdir --parents /home/deploy/passenger'
        execute 'cd ~deploy/cho/current && echo -n "PassengerRuby " > ~deploy/passenger/passenger-ruby-version.cap   && rbenv which ruby >> ~deploy/passenger/passenger-ruby-version.cap'
        execute 'v_passenger_ruby=$(cat ~deploy/passenger/passenger-ruby-version.cap) &&    cp --force /etc/httpd/conf.d/phusion-passenger-default-ruby.conf ~deploy/passenger/passenger-ruby-version.tmp &&    sed -i -e "s|.*PassengerRuby.*|${v_passenger_ruby}|" ~deploy/passenger/passenger-ruby-version.tmp'
        execute 'cat ~deploy/passenger/passenger-ruby-version.tmp > /etc/httpd/conf.d/phusion-passenger-default-ruby.conf'
        execute 'sudo /bin/systemctl restart httpd'
      end
    end
  end
  after :published, 'passenger:config_update'
end

# Used to keep x-1 instances of ruby on a machine.  Ex +4 leaves 3 versions on a machine.  +3 leaves 2 versions
namespace :rbenv_custom_ruby_cleanup do
  desc 'Clean up old rbenv versions'
  task :purge_old_versions do
    on roles(:web) do
      execute 'ls -dt ~deploy/.rbenv/versions/*/ | tail -n +3 | xargs rm -rf'
    end
  end
  after 'deploy:finishing', 'rbenv_custom_ruby_cleanup:purge_old_versions'
end
