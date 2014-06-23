require 'rails_helper'

describe AnonymousFeedbackController, :type => :controller do
  before do
    login_as create(:feedex_user)
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

  context "valid input, problem reports" do
    let!(:feedback) do
      create(:problem_report,
        what_wrong: "A",
        what_doing: "B",
        url: "https://www.gov.uk/tax-disc",
        referrer: "https://www.gov.uk/browse",
        user_agent: "Safari",
      )
    end

    context "HTML representation" do
      it "renders the results" do
        get :index, path: "/tax-disc"
        expect(response).to have_http_status(:success)
      end

      it "displays at most 50 results per page" do
        create_list(:problem_report, 70, url: "https://www.gov.uk/tax-disc")
        get :index, path: "/tax-disc"
        expect(assigns["feedback"]).to have(50).items
      end
    end

    context "JSON" do
      render_views

      it "returns the results for problem" do
        get :index, { "path" => "/tax-disc", "format" => "json" }

        expect(response).to have_http_status(:success)
        expect(json_response).to have(1).item
        expect(json_response.first).to include(
          "id" => feedback.id,
          "type" => "problem-report",
          "what_wrong" => "A",
          "what_doing" => "B",
          "url" => "https://www.gov.uk/tax-disc",
          "referrer" => "https://www.gov.uk/browse",
          "user_agent" => "Safari",
        )
      end
    end
  end

  context "valid input, long-form feedback" do
    let!(:feedback) do
      create(:long_form_contact,
        url: "https://www.gov.uk/tax-disc",
        referrer: "https://www.gov.uk/contact/govuk",
        details: "Abc def",
        user_agent: "Safari",
      )
    end

    context "HTML representation" do
      it "renders the results for an HTML request" do
        get :index, path: "/tax-disc"
        expect(response).to have_http_status(:success)
      end
    end

    context "JSON representation" do
      render_views

      it "returns the results for problem" do
        get :index, { "path" => "/tax-disc", "format" => "json" }

        expect(response).to have_http_status(:success)
        expect(json_response).to have(1).item
        expect(json_response.first).to include(
          "id" => feedback.id,
          "type" => "long-form-contact",
          "details" => "Abc def",
          "url" => "https://www.gov.uk/tax-disc",
          "referrer" => "https://www.gov.uk/contact/govuk",
          "user_agent" => "Safari",
        )
      end
    end
  end

  context "valid input, service feedback" do
    let!(:feedback) do
      create(:service_feedback,
        slug: "apply-carers-allowance",
        url: "https://www.gov.uk/done/apply-carers-allowance",
        details: "It's great",
        service_satisfaction_rating: 5,
        user_agent: "Safari",
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
          "id" => feedback.id,
          "type" => "service-feedback",
          "slug" => "apply-carers-allowance",
          "details" => "It's great",
          "url" => "https://www.gov.uk/done/apply-carers-allowance",
          "service_satisfaction_rating" => 5,
          "user_agent" => "Safari",
        )
      end
    end
  end
end
