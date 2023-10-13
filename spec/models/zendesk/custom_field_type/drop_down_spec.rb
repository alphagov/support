require "rails_helper"

describe Zendesk::CustomFieldType::DropDown do
  let(:subject) do
    described_class.new(
      id: 123,
      name: "Reason for the request",
      options: {
        "name_tag1" => "Factual inaccuracy",
        "name_tag2" => "Missing information",
      },
    )
  end

  describe "#prepare_value" do
    it "returns tag name given form input" do
      input = "Factual inaccuracy"

      expect(subject.prepare_value(input)).to eq("name_tag1")
    end

    it "raises an error for invalid label" do
      input = "Personal whim"

      expect { subject.prepare_value(input) }.to raise_error(
        "Unable to find name tag for 'Personal whim' to populate custom fields. " \
        "Ensure it's defined in config/zendesk/custom_fields_data.yml",
      )
    end
  end
end
