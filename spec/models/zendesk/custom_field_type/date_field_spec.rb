require "rails_helper"

describe Zendesk::CustomFieldType::DateField do
  let(:subject) { described_class.new(id: 123, name: "Deadline") }

  describe "#prepare_value" do
    it "returns date in the ISO 8601 date format (extended) given default form input" do
      input = "02-08-2023"

      expect(subject.prepare_value(input)).to eq("2023-08-02")
    end

    it "returns date in the ISO 8601 date format (extended) given valid form input" do
      input = "2023-08-02"

      expect(subject.prepare_value(input)).to eq("2023-08-02")
    end

    it "returns date in the ISO 8601 date format (extended) given ISO 8601 formatted date with time and timezone" do
      input = "2023-08-02T20:49:15Z"

      expect(subject.prepare_value(input)).to eq("2023-08-02")
    end

    it "returns date in the ISO 8601 date format (extended) given ISO 8601 formatted date string with time" do
      input = "2023-08-02T18:21:06"

      expect(subject.prepare_value(input)).to eq("2023-08-02")
    end

    it "returns date in the ISO 8601 date format (extended) given RFC 2822 formatted string" do
      input = "Wed, 02 Aug 2023 21:49:15 BST"

      expect(subject.prepare_value(input)).to eq("2023-08-02")
    end

    it "raises an error given unparsable date" do
      input = "02-13-2023"

      expect { subject.prepare_value(input) }.to raise_error(Date::Error)
    end
  end
end
