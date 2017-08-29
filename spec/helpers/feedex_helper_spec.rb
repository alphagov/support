require 'rails_helper'

describe FeedexHelper, type: :helper do
  include FeedexHelper

  context "#total_responses_header" do
    let(:header) {
      total_responses_header(
        total_count: total_count,
        from: from,
        to: to,
        results_limited: results_limited,
        scopes: ScopeFiltersPresenter.new(path: path)
      )
    }

    let(:results_limited) { false }
    let(:path) {"/vat-rates"}

    context "when the page has no ratings" do
      context "with no dates and a total_count of 1" do
        let(:total_count) { 1 }
        let(:from) { nil }
        let(:to) { nil }

        it "outputs total_count" do
          expect(header).to eq("1 response")
        end
      end
    end
    context "when the page has ratings" do
      let(:total_count) { 1 }
      let(:from) { nil }
      let(:to) { nil }
      let(:path) {"/done/register-to-vote"}

      context "with no dates and a total_count of 1" do
        it "doesn't output the responses" do
          expect(header).to eq "All responses"
        end
      end

      context "with dates and a total_count of 1" do
        let(:total_count) { 1 }
        let(:from) { "10 May 2015" }
        let(:to) { "11 May 2015" }

        it "outputs the dates only" do
          expect(header).to eq "Responses between 10 May 2015 and 11 May 2015"
        end
      end
    end

    context "with no dates and a total_count more than 1" do
      let(:total_count) { 1000 }
      let(:from) { nil }
      let(:to) { nil }

      it "outputs total_count" do
        expect(header).to eq("All 1,000 responses")
      end
    end

    context "with only a from date" do
      let(:total_count) { 1000 }
      let(:from) { "10 May 2015" }
      let(:to) { nil }

      it "outputs total_count and from date" do
        expect(header).to eq("1,000 responses since 10 May 2015")
      end
    end

    context "with only a to date" do
      let(:total_count) { 1000 }
      let(:from) { nil }
      let(:to) { "11 May 2015" }

      it "outputs total_count and to date" do
        expect(header).to eq("1,000 responses before 11 May 2015")
      end
    end

    context "with both a from and to date" do
      let(:total_count) { 1000 }
      let(:from) { "10 May 2015" }
      let(:to) { "11 May 2015" }

      it "outputs total_count and both dates" do
        expect(header).to eq("1,000 responses between 10 May 2015 and 11 May 2015")
      end
    end

    context "with limited results" do
      let(:total_count) { 10000 }
      let(:from) { nil }
      let(:to) { nil }
      let(:results_limited) { true }

      it "outputs total_count" do
        expect(header).to eq("Over 10,000 responses")
      end
    end

    context "with limited results and dates" do
      let(:total_count) { 10000 }
      let(:from) { "10 May 2015" }
      let(:to) { "11 May 2015" }
      let(:results_limited) { true }

      it "outputs total_count" do
        expect(header).to eq("Over 10,000 responses between 10 May 2015 and 11 May 2015")
      end
    end
  end
end
