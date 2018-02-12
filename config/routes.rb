# frozen_string_literal: true

Rails.application.routes.draw do
  resources :test_models
  mount Blacklight::Engine => '/'
  root to: 'catalog#index'
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  resources :work_submissions, as: 'works', path: '/works', except: [:show, :index], controller: 'work/submissions'
  resources :archival_collections, except: [:show, :index], controller: 'collection/archival_collections'
  resources :library_collections, except: [:show, :index], controller: 'collection/library_collections'
  resources :curated_collections, except: [:show, :index], controller: 'collection/curated_collections'
  resources :data_dictionary_fields, controller: 'data_dictionary/fields'
end
