require 'rails_helper'
require 'gds_api/test_helpers/support_api'

describe AnonymousFeedbackController, :type => :controller do
  include GdsApi::TestHelpers::SupportApi

  before do
    login_as create(:user)
  end

  describe "#index" do
    context "with invalid input" do
      it "redirects to the explore endpoint when no path given" do
        get :index
        expect(response).to redirect_to(anonymous_feedback_explore_url)
      end
    end

    context "with valid input" do
      let(:starting_with_path) { "/tax-disc" }

      before do
        stub_get_anonymous_feedback(
          {
            starting_with_path: starting_with_path,
          },
          response_body: {
            "current_page" => 1,
            "pages" => 1,
            "page_size" => 1,
            "results" => [
              {
                type: :problem_report,
                path: "/vat-rates",
                created_at: DateTime.parse("2013-03-01"),
                what_doing: "looking at 3rd paragraph",
                what_wrong: "typo in 2rd word",
                referrer: "https://www.gov.uk",
              },
            ],
          }.to_json
        )
      end

      it "is successful" do
        get :index, path: starting_with_path
        expect(response).to have_http_status(:success)
      end
    end
  end
end
