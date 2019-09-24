require "rails_helper"
require "gds_api/test_helpers/support_api"

describe AnonymousFeedback::DocumentTypesController, type: :controller do
  include GdsApi::TestHelpers::SupportApi

  let(:smart_answer_last_7_days_summary_results) do
    {
      "title" => "Smart Survey",
      "document_type" => "smart_answer",
      "anonymous_feedback_counts" => [
        { path: "/vat-rates", last_7_days: 5, last_30_days: 10, last_90_days: 20 },
        { path: "/done" },
        { path: "/vehicle-tax" },
      ],
    }
  end

  before do
    stub_support_api_anonymous_feedback_doc_type_summary(
      "smart_answer",
      "last_7_days",
      smart_answer_last_7_days_summary_results,
    )
    login_as create(:user, organisation_slug: "cabinet-office")
  end

  describe "#show" do
    it "makes a successful request" do
      get :show, params: { document_type: "smart_answer" }
      expect(response).to have_http_status(200)
    end
  end
end
