class TestModel < ApplicationRecord
  attr_accessor :files_data
  include FileUploader::Attachment.new(:files) # adds an `file` virtual attribute
end
