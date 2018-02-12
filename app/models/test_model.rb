class TestModel < ApplicationRecord
  attr_accessor :image_name, :image_uid
  dragonfly_accessor :image
end
