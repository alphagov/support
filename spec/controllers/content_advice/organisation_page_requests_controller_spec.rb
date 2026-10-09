require "rails_helper"

describe ContentAdvice::OrganisationPageRequestsController, type: :controller do
  def valid_requested_user_params
    {
      "name" => "subject",
      "email" => "subject@digital.cabinet-office.gov.uk",
    }
  end

  def valid_organisation_page_request_params
    {
      "support_requests_content_advice_organisation_page_request" => {
        "requester_attributes" => valid_requester_params,
        **valid_requested_user_params,
        organisation_name: "My new org",
        organisation_abbreviation: "MNO",
        logo_type: "Plain text",
        sis_logo_format: "",
        plain_text_logo_format: "Stacked",
        gcs_exemption: "",
        parent_organisation: "A parent org",
        organisation_type: "Other",
        organisation_status: "Coming soon",
        exempt_from_govuk: "",
        associated_organisations: "AO1, AO2",
        alternative_format_email: "test@example.com",
        govuk_lead_name: "Test Person",
        govuk_lead_email: "test-person@example.com",
        additional_info: "Additional information",
        deadline: "No",
      },
    }
  end

  before do
    login_as create(:content_requester)
  end

  it "submits the request to Zendesk" do
    stub_ticket_creation = stub_support_api_valid_raise_support_ticket(
      hash_including("tags" => %w[govt_form dept_content_advice]),
    )

    post :create, params: valid_organisation_page_request_params

    expect(stub_ticket_creation).to have_been_made
  end
end
