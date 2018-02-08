class TestModel < ApplicationRecord
  attr_accessor :file_data
  include FileUploader::Attachment.new(:file) # adds an `file` virtual attribute
end
