require "rails_helper"

describe Zendesk::CustomField do
  before { stub_custom_fields_data }

  describe "#set" do
    it "returns a hash with id and correct value for a date field" do
      properties = described_class.set(id: 123, input: "02-08-2023")

      expect(properties).to eq({ "id" => 123, "value" => "2023-08-02" })
    end

    it "returns a hash with id and correct value for a drop down field" do
      properties = described_class.set(id: 456, input: "Factual inaccuracy")

      expect(properties).to eq({ "id" => 456, "value" => "name_tag1" })
    end

    it "returns a hash with id and correct value for a text field" do
      properties = described_class.set(id: 789, input: "https://gov.uk")

      expect(properties).to eq({ "id" => 789, "value" => "https://gov.uk" })
    end

    it "raises an error given invalid custom field id" do
      expect { described_class.set(id: 11_111, input: "02-08-2023") }.to raise_error(
        "Unable to find custom field ID: 11111. " \
        "Ensure it's defined in config/zendesk/custom_fields_data.yml",
      )
    end
  end

  describe "#options_for_name" do
    it "returns an array of options for a custom field" do
      options = described_class.options_for_name("Reason for the request")

      expect(options).to eq(["Factual inaccuracy"])
    end

    it "raises an error given invalid custom field name" do
      expect { described_class.options_for_name("Not defined list") }.to raise_error(
        "Unable to find custom field name: Not defined list. " \
        "Ensure it's defined in config/zendesk/custom_fields_data.yml",
      )
    end

    it "raises an error if the custom field doesn't have options defined" do
      expect { described_class.options_for_name("Deadline") }.to raise_error(NoMethodError)
    end
  end

  describe "#options_hash" do
    it "returns a hash of options for a custom field" do
      options = described_class.options_hash("Reason for the request")

      expect(options).to eq({ "name_tag1" => "Factual inaccuracy" })
    end

    it "raises an error given invalid custom field name" do
      expect { described_class.options_hash("Not defined list") }.to raise_error(
        "Unable to find custom field name: Not defined list. " \
        "Ensure it's defined in config/zendesk/custom_fields_data.yml",
      )
    end

    it "raises an error if the custom field doesn't have options defined" do
      expect { described_class.options_hash("Deadline") }.to raise_error(NoMethodError)
    end
  end
end
