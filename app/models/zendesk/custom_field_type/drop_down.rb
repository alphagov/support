module Zendesk
  module CustomFieldType
    class DropDown < Base
      attr_reader :id, :name, :options

      def initialize(args)
        @options = args[:options]

        super
      end

      def prepare_value(input)
        name_tag = find_name_tag(input)

        if name_tag.nil?
          raise "Unable to find name tag for '#{input}' to populate custom fields. " \
            "Ensure it's defined in config/zendesk/custom_fields_data.yml"
        end

        name_tag
      end

    private

      def find_name_tag(input)
        options&.key(input)
      end
    end
  end
end
