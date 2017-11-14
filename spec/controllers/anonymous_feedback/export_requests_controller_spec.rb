require 'rails_helper'
require 'gds_api/test_helpers/support_api'

describe AnonymousFeedback::ExportRequestsController, type: :controller do
  include GdsApi::TestHelpers::SupportApi

  let(:user) { create(:user, organisation_slug: "cabinet-office", email: "foo.bar@example.gov.uk") }
  before do
    login_as user
  end

  describe "#create" do
    shared_examples "a successful create request" do
      it "passes the user's email to the api" do
        do_request
        expect(stub_request).to have_been_made
      end

      it "sets the flash" do
        do_request

        expect(flash[:notice]).to include "foo.bar@example.gov.uk"
      end
    end

    context "with a path" do
      let!(:stub_request) do
        stub_support_api_feedback_export_request_creation(notification_email: "foo.bar@example.gov.uk",
                                                      path_prefix: "/foo",
                                                      from: "2015-05-01",
                                                      to: "2015-06-01",
                                                      organisation: nil)
      end

      let(:do_request) { post :create, params: { path: "/foo", from: "2015-05-01", to: "2015-06-01" } }

      it_behaves_like "a successful create request"

      it "redirects back to the list" do
        do_request

        expect(response).to redirect_to(anonymous_feedback_index_path(path: "/foo",
                                                                      from: "2015-05-01",
                                                                      to: "2015-06-01"))
      end

      it "normalises the path before sending it to the api" do
        post :create, params: { path: "foo", from: "2015-05-01", to: "2015-06-01" }

        expect(stub_request).to have_been_made
      end
    end

    context "with an organisation" do
      let!(:stub_request) do
        stub_support_api_feedback_export_request_creation(notification_email: "foo.bar@example.gov.uk",
                                                      path_prefix: nil,
                                                      from: "2015-05-01",
                                                      to: "2015-06-01",
                                                      organisation: "hm-revenue-customs")
      end

      let(:do_request) { post :create, params: { organisation: "hm-revenue-customs", from: "2015-05-01", to: "2015-06-01" } }

      it_behaves_like "a successful create request"

      it "redirects back to the list" do
        do_request

        expect(response).to redirect_to(anonymous_feedback_index_path(organisation: "hm-revenue-customs",
                                                                      from: "2015-05-01",
                                                                      to: "2015-06-01"))
      end
    end
  end

  describe "#show" do
    let(:filename) { "feedex_0000-00-00_2015-05-28_vat-rates.csv" }

    context "with a ready file" do
      before { stub_support_api_feedback_export_request(1, ready: true, filename: filename) }

      it "sends the relevant file" do
        # NOTE send_file acts as a render call, so to avoid breaking the controller
        # we need to pretend to do something here, as a nil stub will cause a
        # ActionController::UnknownFormat error because it is falling throug
        # to the default render.  Doing `head :ok` is enough.
        expect(controller).to receive(:send_file).with("/data/uploads/support-api/csvs/#{filename}") do
          controller.head(:ok)
        end
        allow(controller).to receive(:render)

        get :show, params: { id: 1 }
      end
    end

    context "with a pending file" do
      before { stub_support_api_feedback_export_request(2, ready: false, filename: filename) }

      it "replies with a 404" do
        get :show, params: { id: 2 }

        expect(response).to be_not_found
      end
    end
  end
end
