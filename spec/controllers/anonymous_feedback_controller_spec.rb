require 'rails_helper'
require 'gds_api/test_helpers/support_api'

describe AnonymousFeedbackController, type: :controller do
  include GdsApi::TestHelpers::SupportApi
  before do
    login_as create(:user)
    stub_support_api_organisations_list
    stub_support_api_document_type_list
  end

  context "when no `paths` or `organisation` given" do
    context "HTML representation" do
      it "redirects to the explore endpoint" do
        get :index
        expect(response).to redirect_to(anonymous_feedback_explore_url)
      end
    end

    context "JSON" do
      it "returns an error" do
        get :index, params: { format: :json }
        expect(response).to have_http_status(400)
        expect(json_response).to eq("errors" => ["Please provide a valid 'paths', 'path' or 'organisation' parameter"])
      end
    end
  end

  context "no results" do
    context "on the first page" do
      it "should show no results" do
        stub_support_api_anonymous_feedback(
          { path_prefixes: ["/a"] },
          "results" => [], "pages" => 0, "current_page" => 1,
        )

        get :index, params: { "paths" => "/a", "format" => "json" }

        expect(json_response).to have(0).items
      end
    end

    context "user has manually entered a non-existent page" do
      it "should redirect to the first page" do
        stub_support_api_anonymous_feedback(
          { path_prefixes: ["/a"], page: "4" },
          "results" => [], "pages" => 3, "current_page" => 4,
        )

        get :index, params: { paths: "/a", page: 4 }

        expect(response).to redirect_to(anonymous_feedback_index_path(paths: ["/a"], page: 1))
      end
    end
  end

  context "browsing by path" do
    context "valid input, problem reports" do
      before do
        stub_support_api_anonymous_feedback(
          { path_prefixes: ["/tax-disc"], from: "13/10/2014", to: "25th November 2014" },
          "current_page" => 1,
          "pages" => 1,
          "page_size" => 1,
          "results" => [
            {
              id: "123",
              type: "problem-report",
              path: "/tax-disc",
              url: "http://www.dev.gov.uk/tax-disc",
              created_at: Date.parse("2013-03-01"),
              what_doing: "looking at 3rd paragraph",
              what_wrong: "typo in 2rd word",
              referrer: "https://www.gov.uk",
              user_agent: "Safari",
            },
          ]
        )
      end

      context "HTML representation" do
        it "renders the results given raw paths" do
          get :index, params: { paths: "/tax-disc", from: "13/10/2014", to: "25th November 2014" }
          expect(response).to have_http_status(:success)
        end

        it "renders the results given a saved paths ID" do
          saved_paths = Support::Requests::Anonymous::Paths.new(%w(/tax-disc))
          saved_paths.save

          get :index, params: { paths: saved_paths.id, from: "13/10/2014", to: "25th November 2014" }

          expect(response).to have_http_status(:success)
        end
      end

      context "JSON" do
        render_views

        it "returns the results for problem" do
          get :index, params: { "paths" => "/tax-disc", "format" => "json", from: "13/10/2014", to: "25th November 2014" }

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
        stub_support_api_anonymous_feedback(
          { path_prefixes: ["/contact/govuk"] },
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
          ]
        )
      end

      context "HTML representation" do
        it "renders the results for an HTML request" do
          get :index, params: { paths: "/contact/govuk" }
          expect(response).to have_http_status(:success)
        end
      end

      context "JSON representation" do
        render_views

        it "returns the results for problem" do
          get :index, params: { "paths" => "/contact/govuk", "format" => "json" }

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
        stub_support_api_anonymous_feedback(
          { path_prefixes: ["/done/apply-carers-allowance"] },
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
          ]
        )
      end

      context "HTML representation" do
        it "renders the results" do
          get :index, params: { paths: "/done/apply-carers-allowance" }
          expect(response).to have_http_status(:success)
        end
      end

      context "JSON representation" do
        render_views

        it "returns the results" do
          get :index, params: { "paths" => "/done/apply-carers-allowance", "format" => "json" }

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

    it "normalises the path before talking to the api" do
      api_request = stub_support_api_anonymous_feedback(
        hash_including("path_prefixes" => ["/done/apply-carers-allowance"]),
        "results" => [], "pages" => 0, "current_page" => 1
      )

      get :index, params: { paths: "done/apply-carers-allowance" }

      expect(api_request).to have_been_made
    end

    it "normalises all paths before talking to the api" do
      api_request = stub_support_api_anonymous_feedback(
        hash_including("path_prefixes" => ["/done/apply-carers-allowance", "/start/vat-rates"]),
        "results" => [], "pages" => 0, "current_page" => 1
      )

      get :index, params: { paths: "/done/apply-carers-allowance, https://gov.uk/start/vat-rates" }

      expect(api_request).to have_been_made
    end
  end

  context "for an organisation" do
    render_views

    before do
      stub_support_api_anonymous_feedback(
        { organisation_slug: "cabinet-office" },
        "current_page" => 1,
        "pages" => 1,
        "page_size" => 1,
        "results" => [
          {
            id: "123",
            type: "problem-report",
            path: "/government/organisations/cabinet-office",
            url: "http://www.dev.gov.uk/government/organisations/cabinet-office",
            created_at: Date.parse("2013-03-01"),
            what_doing: "looking at 3rd paragraph",
            what_wrong: "typo in 2rd word",
            referrer: "https://www.gov.uk",
            user_agent: "Safari",
          },
        ]
      )
      stub_support_api_organisation("cabinet-office")
    end

    it "resolves the slug to a title" do
      get :index, params: { organisation: "cabinet-office" }

      expect(response.body).to include "Cabinet Office"
    end
  end
end
