# frozen_string_literal: true

module DisplayTransformation
  class Factory < ItemFactory
    class << self
      alias_method :transformations, :items
      alias_method :transformation_names, :names
      alias_method :transformations=, :items=

      def default_key
        :no_transformation
      end

      private

        def default_items
          { default_key => DisplayTransformation::None.new }
        end

        def item_class
          DisplayTransformation::Base
        end

        def send_error(error_list)
          raise DisplayTransformation::Error.new(
            "Invalid display transformation(s) in transformation list: #{error_list}"
          )
        end
    end
  end
end
