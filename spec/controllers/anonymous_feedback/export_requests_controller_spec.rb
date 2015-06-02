require 'rails_helper'
require 'gds_api/test_helpers/support_api'

describe AnonymousFeedback::ExportRequestsController, type: :controller do
  include GdsApi::TestHelpers::SupportApi

  let(:user) { create(:user, organisation_slug: "cabinet-office", email: "foo.bar@example.gov.uk") }
  before do
    login_as user
  end

  describe "#create" do
    let!(:stub_request) do
      stub_support_feedback_export_request_creation(notification_email: "foo.bar@example.gov.uk",
                                                    path_prefix: "/foo",
                                                    filter_from: "2015-05-01",
                                                    filter_to: "2015-06-01")
    end

    let(:do_request) { post :create, path: "/foo", from: "2015-05-01", to: "2015-06-01" }

    it "passes the user's email to the api" do
      do_request
      expect(stub_request).to have_been_made
    end

    it "sets the flash" do
      do_request

      expect(flash[:notice]).to include "foo.bar@example.gov.uk"
    end

    it "redirects back to the list" do
      do_request

      expect(response).to redirect_to(anonymous_feedback_index_path(path: "/foo",
                                                                    from: "2015-05-01",
                                                                    to: "2015-06-01"))
    end
  end

  describe "#show" do
    let(:filename) { "feedex_0000-00-00_2015-05-28_vat-rates.csv" }

    context "with a ready file" do
      before { stub_support_feedback_export_request(1, ready: true, filename: filename) }

      it "sends the relevant file" do
        expect(controller).to receive(:send_file).with "/data/uploads/support-api/csvs/#{filename}"
        allow(controller).to receive(:render)

        get :show, id: 1
      end
    end

    context "with a pending file" do
      before { stub_support_feedback_export_request(2, ready: false, filename: filename) }

      it "replies with a 404" do
        get :show, id: 2

        expect(response).to be_not_found
      end
    end
  end
end
