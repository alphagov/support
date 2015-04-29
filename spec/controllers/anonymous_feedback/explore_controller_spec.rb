require 'rails_helper'

describe AnonymousFeedback::ExploreController, :type => :controller do
  before do
    login_as create(:user)
  end

  it "shows the new form again for invalid requests" do
    post :create, { support_requests_anonymous_explore_by_url: { url: "" } }
    expect(response).to have_http_status(422)
  end

  it "redirects to the anonymous feedback index page for successful requests" do
    post :create, { support_requests_anonymous_explore_by_url: { url: "https://www.gov.uk/tax-disc" } }
    expect(response).to redirect_to("/anonymous_feedback?path=%2Ftax-disc")
  end
end
