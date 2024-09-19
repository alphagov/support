require "rails_helper"

describe DesignSystemDateHelper, type: :helper do
  include DesignSystemDateHelper
  include ActiveModel::Validations
  include GdsApi::TestHelpers::SupportApi

  context "Date Helper" do
    it "returns formatted date when all input entered are valid" do
      day = "28"
      month = "09"
      year = "1984"

      date_input = formatted_date(day, month, year)

      expect(date_input).to eq("28-09-1984")
    end

    it "returns empty string if any values entered are empty strings" do
      day = ""
      month = "09"
      year = "1984"

      date_input = formatted_date(day, month, year)

      expect(date_input).to eq("")
    end
  end

  context "When Date Helper is receiving invalid date input" do
    it "returns 'provided date is invalid' error message when incorrect day is entered" do
      allow(self).to receive(:errors).and_return(double("errors", add: true))

      day = "abc"
      month = "09"
      year = "1984"

      formatted_date(day, month, year)
      expect(errors).to have_received(:add).with(:base, message: "The provided date is invalid.")
    end

    it "returns 'provided date is invalid' when incorrect month is entered" do
      allow(self).to receive(:errors).and_return(double("errors", add: true))

      day = "28"
      month = "Marchuary"
      year = "1984"

      formatted_date(day, month, year)
      expect(errors).to have_received(:add).with(:base, message: "The provided date is invalid.")
    end

    it "returns 'provided date is invalid' when incorrect year is entered" do
      allow(self).to receive(:errors).and_return(double("errors", add: true))

      day = "28"
      month = "09"
      year = "foo"

      formatted_date(day, month, year)
      expect(errors).to have_received(:add).with(:base, message: "The provided date is invalid.")
    end
  end
end
