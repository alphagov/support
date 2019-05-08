require 'rails_helper'

module Support
  module Requests
    describe EuExitBusinessReadinessRequest do
      subject { described_class.new }
      let(:response_hash) do
        { "sector_business_area" => %w(Accommodation Aerospace),
         "business_activity" =>
          ["Sell products or goods in the UK",
           "Buy products or goods from abroad"],
         "employ_eu_citizens" => ["EU citizens", "No EU citizens"],
         "personal_data" =>
          ["Processing personal data from Europe",
           "Using websites or services hosted in Europe"],
         "intellectual_property" =>
          ["Copyright", "Trade marks", "Designs"],
         "eu_uk_government_funding" => ["EU funding", "UK government funding"],
         "public_sector_procurement" =>
          ["Civil government contracts", "Defence contracts"] }
      end
      before do
        allow(subject).to receive(:grouped_facet_values).and_return(response_hash)
      end

      it { should validate_presence_of(:url) }

      describe 'sector_options' do
        it "returns an array of facet values for Sector" do
          expect(subject.sector_options).to eq(%w(Accommodation Aerospace))
        end
      end

      describe 'organisation_activity_options' do
        it "returns an array of facet values for Organisation activity" do
          expect(subject.organisation_activity_options).to eq(["Sell products or goods in the UK", "Buy products or goods from abroad"])
        end
      end

      describe 'personal_data_options' do
        it "returns an array of facet values for Personal data" do
          expect(subject.personal_data_options).to eq(["Processing personal data from Europe", "Using websites or services hosted in Europe"])
        end
      end

      describe 'intellectual_property_options' do
        it "returns an array of facet values for Intellectual property" do
          expect(subject.intellectual_property_options).to eq(["Copyright", "Trade marks", "Designs"])
        end
      end

      describe 'founding_schemes_options' do
        it "returns an array of facet values for EU or UK government funding" do
          expect(subject.founding_schemes_options).to eq(["EU funding", "UK government funding"])
        end
      end

      describe 'public_sector_procurement_options' do
        it "returns an array of facet values for Public sector procurement" do
          expect(subject.public_sector_procurement_options).to eq(["Civil government contracts", "Defence contracts"])
        end
      end
    end
  end
end
