require "rails_helper"

describe ErrorsHelper, type: :helper do
  include ErrorsHelper

  describe "#errors_for" do
    before do
      @object_with_no_errors = ErrorTestObject.new("title", Time.zone.today)
      @object_with_errors = ErrorTestObject.new(nil, nil)
      @object_with_unrelated_errors = ErrorTestObject.new("title", nil)
      @object_with_no_errors.validate
      @object_with_errors.validate
      @object_with_unrelated_errors.validate
    end

    it "returns errors in a govuk_publishing_components error_items format" do
      expect(@object_with_errors.errors[:title].count).to eq(1)

      result = errors_for(@object_with_errors.errors, :title)
      expect(result).to eq([{ text: "Title can't be blank" }])
    end

    it "returns all errors when there are multiple" do
      expect(@object_with_errors.errors[:date].count).to eq(2)

      result = errors_for(@object_with_errors.errors, :date)
      expect(result).to eq([
        { text: "Date can't be blank" },
        { text: "Date is invalid" },
      ])
    end

    it "returns nil when there are unrelated errors" do
      expect(@object_with_unrelated_errors.errors).not_to be_blank

      result = errors_for(@object_with_unrelated_errors.errors, :title)
      expect(result).to be_nil
    end

    it "returns nil when there are no errors" do
      expect(@object_with_no_errors.errors).to be_blank

      result = errors_for(@object_with_no_errors.errors, :title)
      expect(result).to be_nil
    end
  end
end

class ErrorTestObject
  include ActiveModel::Model
  attr_accessor :title, :date

  validates :title, :date, presence: true
  validate :date_is_a_date

  def initialize(title, date)
    @title = title
    @date = date
  end

  def date_is_a_date
    errors.add(:date, :invalid) unless date.is_a?(Date)
  end
end
