# frozen_string_literal: true

module Transaction
  module Operations
    module Shared
      class Save
        include Dry::Transaction::Operation

        def call(change_set, persister:)
          change_set.sync
          Success(persister.save(resource: change_set))
        rescue StandardError => error
          change_set.errors.add(:save, error.message)
          Failure(change_set)
        end
      end
    end
  end
end