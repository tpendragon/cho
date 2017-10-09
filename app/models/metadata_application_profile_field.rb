# frozen_string_literal: true

class MetadataApplicationProfileField < ApplicationRecord
  include WithRequirementDesignation
  include WithFieldType
  include WithValidation
end
