class TestModel < ApplicationRecord
  include FileUploader::Attachment.new(:file) # adds an `file` virtual attribute
end
