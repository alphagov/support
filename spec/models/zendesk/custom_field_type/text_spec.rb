require "rails_helper"

describe Zendesk::CustomFieldType::Text do
  let(:subject) { described_class.new(id: 123, name: "Not before time") }

  describe "#prepare_value" do
    it "returns a string" do
      input = 10

      expect(subject.prepare_value(input)).to eq("10")
    end
  end
end
