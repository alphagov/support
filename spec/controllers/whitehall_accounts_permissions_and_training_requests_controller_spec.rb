require "rails_helper"

describe WhitehallAccountsPermissionsAndTrainingRequestsController, type: :controller do
  context "submitting request to create or train with a Whitehall account" do
    let(:google_form_url) { "www.googledocs.com/sign_up_to_whitehall" }

    before do
      login_as create(:user_who_can_access_everything)
    end

    it "redirects to Whitehall form" do
      allow_any_instance_of(described_class).to receive(:whitehall_signup_form_url).and_return(google_form_url)

      get :new

      expect(response).to redirect_to(google_form_url)
    end
  end
end
