module SupportApiMockingExtensions
  def expect_support_api_to_receive_raise_ticket(opts)
    stub_support_api_valid_raise_support_ticket(hash_including(opts))
  end

  def stub_custom_fields_data(opts = [])
    fixture_data = YAML.safe_load_file(
      "spec/fixtures/zendesk_custom_fields_data.yml",
      permitted_classes: [
        Zendesk::CustomFieldType::DateField,
        Zendesk::CustomFieldType::DropDown,
        Zendesk::CustomFieldType::Text,
      ],
    )
    fixture_data += opts if opts.present?

    stub_const("Zendesk::CustomField::CUSTOM_FIELDS_DATA", fixture_data)
  end
end

RSpec.configure do |c|
  c.include SupportApiMockingExtensions
end
