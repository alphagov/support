require 'rails_helper'
require 'gds_api/test_helpers/support_api'

describe AnonymousFeedback::ExploreController, type: :controller do
  include GdsApi::TestHelpers::SupportApi
  before do
    stub_support_api_organisations_list([
      {
        slug: "cabinet-office",
        web_url: "https://www.gov.uk/government/organisations/cabinet-office",
        title: "Cabinet Office",
        acronym: "CO",
        govuk_status: "live"
      }, {
        slug: "ministry-of-magic",
        web_url: "https://www.gov.uk/government/organisations/ministry-of-magic",
        title: "Ministry of Magic",
        acronym: "",
        govuk_status: "transitioning"
      }
    ])

    stub_support_api_document_type_list(%w[case_study smart_answer])

    login_as create(:user, organisation_slug: "cabinet-office")
  end

  it "shows the new form again for invalid requests" do
    post :create, params: { support_requests_anonymous_explore_by_multiple_paths: { list_of_urls: "" } }
    expect(response).to have_http_status(422)
    expect(assigns(:explore_by_multiple_paths)).to be_present
  end

  it "shows the new form again for invalid organisation requests" do
    post :create, params: { support_requests_anonymous_explore_by_organisation: { organisation: "" } }
    expect(response).to have_http_status(422)
    expect(assigns(:explore_by_document_type)).to be_present
  end

  it "shows the new form again for invalid document type requests" do
    post :create, params: { support_requests_anonymous_explore_by_document_type: { document_type: "" } }
    expect(response).to have_http_status(422)
    expect(assigns(:explore_by_document_type)).to be_present
  end

  context "#new" do
    before do
      get :new
    end

    it "defaults to the user's organisation" do
      expect(assigns(:explore_by_organisation).organisation).to eq("cabinet-office")
    end

    it "lists the available organisations" do
      expect(assigns(:organisations_list)).to eq([
        ["Cabinet Office (CO)", "cabinet-office"],
        ["Ministry of Magic [Transitioning]", "ministry-of-magic"]
      ])
    end

    it "lists the available document types" do
      expect(assigns(:document_type_list)).to eq([["Case Study", "case_study"], ["Smart Answer", "smart_answer"]])
    end
  end

  context "with a successful request" do
    context "when exploring by URL" do
      it "redirects to the anonymous feedback index page" do
        post :create, params: { support_requests_anonymous_explore_by_multiple_paths: { list_of_urls: "https://www.gov.uk/tax-disc, /vat-rates, /guidance/" } }
        expect(response.location).to start_with("http://test.host/anonymous_feedback?paths=")
      end
    end

    context "when exploring by uploaded URL list" do
      it "redirects to the anonymous feedback index page" do
        post :create, params: { support_requests_anonymous_explore_by_multiple_paths: { uploaded_list: fixture_file_upload(Rails.root.join("spec", "fixtures", "list_of_urls.csv"), 'text/plain') } }
        expect(response.location).to start_with("http://test.host/anonymous_feedback?paths=")
      end
    end

    context "when exploring by organisation" do
      let(:org) { "department-of-fair-dos" }
      let(:attributes) { { organisation: org } }
      let(:redirect_path) { "/anonymous_feedback/organisations/#{org}" }

      it "redirects to anonymous_feedback/organisations#show" do
        post :create,
             params: { support_requests_anonymous_explore_by_organisation: attributes }

        expect(response).to redirect_to(redirect_path)
      end
    end

    context "when exploring by document type" do
      it "redirects to the anonymous feedback index page" do
        post :create, params: { support_requests_anonymous_explore_by_document_type: { document_type: "smart_answer" } }
        expect(response).to redirect_to("/anonymous_feedback/document_types/smart_answer")
      end
    end
  end
end
