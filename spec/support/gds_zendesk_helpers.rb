require "gds_zendesk/test_helpers"

module ZendeskRequestMockingExtensions
  def expect_zendesk_to_receive_ticket(opts)
    stub_zendesk_ticket_creation_with_body("ticket" => hash_including(opts))
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
  c.include GDSZendesk::TestHelpers
  c.include ZendeskRequestMockingExtensions

  c.before(:context) do
    self.valid_zendesk_credentials = ZENDESK_CREDENTIALS
  end
end
