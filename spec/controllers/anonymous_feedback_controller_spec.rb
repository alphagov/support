require 'rails_helper'
require 'gds_api/test_helpers/support_api'

describe AnonymousFeedbackController, :type => :controller do
  include GdsApi::TestHelpers::SupportApi
  before do
    login_as create(:user)
  end

  context "invalid input" do
    context "HTML representation" do
      it "redirects to the explore endpoint when no path given" do
        get :index
        expect(response).to redirect_to(anonymous_feedback_explore_url)
      end
    end

    context "JSON" do
      it "returns an error when no path given" do
        get :index, format: :json
        expect(response).to have_http_status(400)
        expect(json_response).to eq("errors" => ["Please set a valid 'path' parameter"])
      end
    end
  end

  context "no results" do
    context "on the first page" do
      it "should show no results" do
        stub_anonymous_feedback(
          { path_prefix: "/a" },
          { "results" => [], "pages" => 0, "current_page" => 1 },
        )

        get :index, { "path" => "/a", "format" => "json" }

        expect(json_response).to have(0).items
      end
    end

    context "user has manually entered a non-existent page" do
      it "should redirect to the first page" do
        stub_anonymous_feedback(
          { path_prefix: "/a", page: 4 },
          { "results" => [], "pages" => 3, "current_page" => 4 },
        )

        get :index, path: "/a", page: 4

        expect(response).to redirect_to(anonymous_feedback_index_path(path: "/a", page: 1))
      end
    end
  end

  context "valid input, problem reports" do
    before do
      stub_anonymous_feedback(
        { path_prefix: "/tax-disc" },
        {
          "current_page" => 1,
          "pages" => 1,
          "page_size" => 1,
          "results" => [
            {
              id: "123",
              type: "problem-report",
              path: "/tax-disc",
              url: "http://www.dev.gov.uk/tax-disc",
              created_at: DateTime.parse("2013-03-01"),
              what_doing: "looking at 3rd paragraph",
              what_wrong: "typo in 2rd word",
              referrer: "https://www.gov.uk",
              user_agent: "Safari",
            },
          ],
        }
      )
    end

    context "HTML representation" do
      it "renders the results" do
        get :index, path: "/tax-disc"
        expect(response).to have_http_status(:success)
      end
    end

    context "JSON" do
      render_views

      it "returns the results for problem" do
        get :index, { "path" => "/tax-disc", "format" => "json" }

        expect(response).to have_http_status(:success)
        expect(json_response).to have(1).item
        expect(json_response.first).to include(
          "id" => "123",
          "type" => "problem-report",
          "what_wrong" => "typo in 2rd word",
          "what_doing" => "looking at 3rd paragraph",
          "url" => "http://www.dev.gov.uk/tax-disc",
          "referrer" => "https://www.gov.uk",
          "user_agent" => "Safari",
        )
      end
    end
  end

  context "valid input, long-form feedback" do
    before do
      stub_anonymous_feedback(
        { path_prefix: "/contact/govuk" },
        {
          "current_page" => 1,
          "pages" => 1,
          "page_size" => 1,
          "results" => [
            {
              id: "123",
              type: "long-form-contact",
              url: "http://www.dev.gov.uk/contact/govuk",
              path: "/contact/govuk",
              referrer: "https://www.gov.uk/contact",
              details: "Abc def",
              user_agent: "Safari",
            },
          ],
        }
      )
    end

    context "HTML representation" do
      it "renders the results for an HTML request" do
        get :index, path: "/contact/govuk"
        expect(response).to have_http_status(:success)
      end
    end

    context "JSON representation" do
      render_views

      it "returns the results for problem" do
        get :index, { "path" => "/contact/govuk", "format" => "json" }

        expect(response).to have_http_status(:success)
        expect(json_response).to have(1).item
        expect(json_response.first).to include(
          "id" => "123",
          "type" => "long-form-contact",
          "details" => "Abc def",
          "url" => "http://www.dev.gov.uk/contact/govuk",
          "referrer" => "https://www.gov.uk/contact",
          "user_agent" => "Safari",
        )
      end
    end
  end

  context "valid input, service feedback" do
    before do
      stub_anonymous_feedback(
        { path_prefix: "/done/apply-carers-allowance" },
        {
          "current_page" => 1,
          "pages" => 1,
          "page_size" => 1,
          "results" => [
            {
              id: "123",
              type: "service-feedback",
              slug: "apply-carers-allowance",
              url: "http://www.dev.gov.uk/done/apply-carers-allowance",
              path: "/done/apply-carers-allowance",
              details: "It's great",
              service_satisfaction_rating: 5,
              user_agent: "Safari",
            },
          ],
        }
      )
    end

    context "HTML representation" do
      it "renders the results" do
        get :index, path: "/done/apply-carers-allowance"
        expect(response).to have_http_status(:success)
      end
    end

    context "JSON representation" do
      render_views

      it "returns the results" do
        get :index, { "path" => "/done/apply-carers-allowance", "format" => "json" }

        expect(response).to have_http_status(:success)
        expect(json_response).to have(1).item
        expect(json_response.first).to include(
          "id" => "123",
          "type" => "service-feedback",
          "slug" => "apply-carers-allowance",
          "details" => "It's great",
          "url" => "http://www.dev.gov.uk/done/apply-carers-allowance",
          "service_satisfaction_rating" => 5,
          "user_agent" => "Safari",
        )
      end
    end
  end
end
