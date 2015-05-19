require 'rails_helper'

describe AnonymousFeedback::ExploreController, :type => :controller do
  before do
    login_as create(:user)
  end

  it "shows the new form again for invalid requests" do
    post :create, { support_requests_anonymous_explore_by_url: { url: "" } }
    expect(response).to have_http_status(422)
  end

  context "with a successful request" do
    context "when exploring by URL" do
      it "redirects to the anonymous feedback index page" do
        post :create, { support_requests_anonymous_explore_by_url: { url: "https://www.gov.uk/tax-disc" } }
        expect(response).to redirect_to("/anonymous_feedback?path=%2Ftax-disc")
      end
    end

    context "when exploring by organisation" do
      let(:org) { "department-of-fair-dos" }
      let(:attributes) { {organisation: org} }
      let(:redirect_path) { "/anonymous_feedback/organisations/#{org}" }

      it "redirects to anonymous_feedback/organisations#show" do
        post :create,
          { support_requests_anonymous_explore_by_organisation: attributes }

        expect(response).to redirect_to(redirect_path)
      end
    end
  end
end
