require 'rails_helper'

describe OrganisationSummaryPresenter, type: :presenter do
  context "when api_response has no `anonymous_feedback_counts`" do
    let(:api_response) {
      {
        "title" => "Department for Cats",
        "anonymous_feedback_counts" => [],
      }
    }
    subject(:presenter) { OrganisationSummaryPresenter.new(api_response) }

    it "should be empty" do
      expect(presenter).to be_empty
    end

    it "should have zero size" do
      expect(presenter.size).to be_zero
    end

    it "should present api_response's `anonymous_feedback_counts` as an empty array" do
      expect(presenter).to eq([])
    end
  end

  context "when api_response has `anonymous_feedback_counts`" do
    let(:path_a) { "/path-a" }
    let(:path_b) { "/path-b" }
    let(:path_c) { "/path-c" }
    let(:api_response) {
      {
        "title" => "Department for Cats",
        "anonymous_feedback_counts" => [
          { "path" => path_c },
          { "path" => path_a },
          { "path" => path_b },
        ],
      }
    }
    subject(:presenter) { OrganisationSummaryPresenter.new(api_response) }

    it "should match api_response's `anonymous_feedback_counts`" do
      expect(presenter.size).to eql(3)
    end

    it "should sort `anonymous_feedback_counts` by `path`" do
      expect(presenter[0].path).to eql(path_a)
      expect(presenter[1].path).to eql(path_b)
      expect(presenter[2].path).to eql(path_c)
    end
  end
end
