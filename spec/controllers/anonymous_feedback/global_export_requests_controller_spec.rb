require 'rails_helper'
require 'gds_api/test_helpers/support_api'

describe AnonymousFeedback::GlobalExportRequestsController, type: :controller do
  include GdsApi::TestHelpers::SupportApi

  let(:user) do
    create(
      :user,
      organisation_slug: 'cabinet-office',
      email: 'foo.bar@example.gov.uk',
      permissions: %w[signin feedex_exporters]
    )
  end

  before { login_as user }

  describe "#create" do
    let!(:stub_request) do
      stub_support_api_global_export_request_creation(
        notification_email: user.email,
        from_date: "1 Aug 2016",
        to_date: "8 Aug 2016",
        exclude_spam: true
      )
    end

    it "makes a successful create request" do
      post :create, params: { from_date: "1 Aug 2016", to_date: "8 Aug 2016", exclude_spam: '1' }
      expect(stub_request).to have_been_made
    end

    it "sets the flash" do
      post :create, params: { from_date: "1 Aug 2016", to_date: "8 Aug 2016" }
      expect(flash[:notice]).to include 'foo.bar@example.gov.uk'
    end

    it "redirects to the feedback explore page" do
      post :create, params: { from_date: "1 Aug 2016", to_date: "8 Aug 2016" }
      expect(response).to redirect_to(anonymous_feedback_explore_path)
    end
  end
end
