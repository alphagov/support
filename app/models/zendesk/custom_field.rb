module Zendesk
  class CustomField
    CUSTOM_FIELDS_DATA ||= YAML.safe_load_file(
      "config/zendesk/custom_fields_data.yml",
      permitted_classes: [
        Zendesk::CustomFieldType::DateField,
        Zendesk::CustomFieldType::DropDown,
        Zendesk::CustomFieldType::Text,
      ],
    ).freeze

    class << self
      delegate :set, :options_for_name, :options_hash, to: :new
    end

    def set(id:, input:)
      { "id" => id, "value" => find_by_id(id).prepare_value(input) }
    end

    def options_for_name(name)
      find_by_name(name).options.values
    end

    def options_hash(name)
      find_by_name(name).options
    end

  private

    def find_by_id(id)
      field = CUSTOM_FIELDS_DATA.select { |f| f.id == id }.first

      if field.nil?
        raise "Unable to find custom field ID: #{id}. " \
          "Ensure it's defined in config/zendesk/custom_fields_data.yml"
      end

      field
    end

    def find_by_name(name)
      field = CUSTOM_FIELDS_DATA.select { |f| f.name == name }.first

      if field.nil?
        raise "Unable to find custom field name: #{name}. " \
          "Ensure it's defined in config/zendesk/custom_fields_data.yml"
      end

      field
    end
  end
end
