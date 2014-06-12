require 'rails_helper'

RSpec.describe AnonymousFeedback::ExploreController, :type => :controller do
  before do
    login_as create(:feedex_user)
  end

  it "shows the new form again for invalid requests" do
    post :create, { support_requests_anonymous_explore: { by_url: "abc" } }
    expect(response).to have_http_status(400)
  end

  it "redirects to the anonymous feedback index page for successful requests" do
    post :create, { support_requests_anonymous_explore: { by_url: "https://www.gov.uk/tax-disc" } }
    expect(response).to redirect_to("/anonymous_feedback?path=%2Ftax-disc")
  end
end
