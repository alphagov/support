require "rails_helper"

describe ContentAdvice::GroupPageRequestsController, type: :controller do
  def valid_requested_user_params
    {
      "name" => "subject",
      "email" => "subject@digital.cabinet-office.gov.uk",
    }
  end

  def valid_group_page_request_params
    {
      "support_requests_content_advice_group_page_request" => {
        "requester_attributes" => valid_requester_params,
        **valid_requested_user_params,
        "group_name" => "My new group",
        "purpose" => "group purpose",
        "user_needs_evidence" => "evidence for user needs",
        "contact_reason" => "clear reason for contacting the group",
        "additional_info" => "this is the additional info",
        "deadline" => "No",
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

    post :create, params: valid_group_page_request_params

    expect(stub_ticket_creation).to have_been_made
  end
end
