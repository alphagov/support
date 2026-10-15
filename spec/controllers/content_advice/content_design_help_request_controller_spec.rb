require "rails_helper"

describe ContentAdvice::ContentDesignHelpRequestsController, type: :controller do
  def valid_requested_user_params
    {
      "name" => "subject",
      "email" => "subject@digital.cabinet-office.gov.uk",
    }
  end

  def valid_content_design_help_request_params
    {
      "support_requests_content_advice_content_design_help_request" => {
        "requester_attributes" => valid_requester_params,
        **valid_requested_user_params,
        title: "Title of my request",
        advice_needed: "This is the advice I need",
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

    post :create, params: valid_content_design_help_request_params

    expect(stub_ticket_creation).to have_been_made
  end
end
