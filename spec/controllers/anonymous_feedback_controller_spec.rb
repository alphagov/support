require 'rails_helper'

describe AnonymousFeedbackController, :type => :controller do
  before do
    login_as create(:user)
  end

  context "invalid input" do
    it "redirects to the explore endpoint when no path given" do
      get :index
      expect(response).to redirect_to(anonymous_feedback_explore_url)
    end
  end

  context "valid input, problem reports" do
    let!(:feedback) do
      create(:problem_report,
        what_wrong: "A",
        what_doing: "B",
        path: "/tax-disc",
        referrer: "https://www.gov.uk/browse",
        user_agent: "Safari",
      )
    end

    it "renders the results" do
      get :index, path: "/tax-disc"
      expect(response).to have_http_status(:success)
    end

    it "displays at most 50 results per page" do
      create_list(:problem_report, 70, path: "/tax-disc")
      get :index, path: "/tax-disc"
      expect(assigns["feedback"]).to have(50).items
    end
  end

  context "valid input, long-form feedback" do
    let!(:feedback) do
      create(:long_form_contact,
        path: "/tax-disc",
        referrer: "https://www.gov.uk/contact/govuk",
        details: "Abc def",
        user_agent: "Safari",
      )
    end

    it "renders the results for an HTML request" do
      get :index, path: "/tax-disc"
      expect(response).to have_http_status(:success)
    end
  end

  context "valid input, service feedback" do
    let!(:feedback) do
      create(:service_feedback,
        slug: "apply-carers-allowance",
        path: "/done/apply-carers-allowance",
        details: "It's great",
        service_satisfaction_rating: 5,
        user_agent: "Safari",
      )
    end

    it "renders the results" do
      get :index, path: "/done/apply-carers-allowance"
      expect(response).to have_http_status(:success)
    end
  end
end
