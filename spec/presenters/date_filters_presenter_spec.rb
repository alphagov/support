require "rails_helper"

describe DateFiltersPresenter, type: :presenter do
  describe "#filtered?" do
    context "with no actual to and from dates" do
      let(:presenter) {
        DateFiltersPresenter.new(
          requested_from: "10 May 2015",
          requested_to: "11 May 2015",
          actual_from: nil,
          actual_to: nil,
        )
      }

      it "has not been filtered" do
        expect(presenter).not_to be_filtered
      end
    end

    context "with actual from date" do
      let(:presenter) {
        DateFiltersPresenter.new(
          requested_from: "10 May 2015",
          requested_to: "11 May 2015",
          actual_from: "10 May 2015",
          actual_to: nil,
        )
      }

      it "has been filtered" do
        expect(presenter).to be_filtered
      end
    end

    context "with actual to date" do
      let(:presenter) {
        DateFiltersPresenter.new(
          requested_from: "10 May 2015",
          requested_to: "11 May 2015",
          actual_from: nil,
          actual_to: "11 May 2015",
        )
      }

      it "has been filtered" do
        expect(presenter).to be_filtered
      end
    end
  end

  describe "#attempted_to_filter?" do
    context "with no requested to and from dates" do
      let(:presenter) {
        DateFiltersPresenter.new(
          requested_from: nil,
          requested_to: nil,
          actual_from: nil,
          actual_to: nil,
        )
      }

      it "has not attempted to filter" do
        expect(presenter).not_to be_attempted_to_filter
      end
    end

    context "with requested from date" do
      let(:presenter) {
        DateFiltersPresenter.new(
          requested_from: "10 May 2015",
          requested_to: nil,
          actual_from: "10 May 2015",
          actual_to: nil,
        )
      }

      it "has attempted to filter" do
        expect(presenter).to be_attempted_to_filter
      end
    end

    context "with requested to date" do
      let(:presenter) {
        DateFiltersPresenter.new(
          requested_from: nil,
          requested_to: "11 May 2015",
          actual_from: nil,
          actual_to: "11 May 2015",
        )
      }

      it "has attempted to filter" do
        expect(presenter).to be_attempted_to_filter
      end
    end
  end
end
