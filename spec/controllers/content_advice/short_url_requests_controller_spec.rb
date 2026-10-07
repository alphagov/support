require "rails_helper"

describe ContentAdvice::ShortUrlRequestsController, type: :controller do
  def valid_requested_user_params
    {
      "name" => "subject",
      "email" => "subject@digital.cabinet-office.gov.uk",
    }
  end

  def valid_short_url_request_params
    {
      "support_requests_content_advice_short_url_request" => {
        "requester_attributes" => valid_requester_params,
        **valid_requested_user_params,
        "title" => "My title",
        "destination_page" => "/my-short-url",
        "reason" => "this is the reason",
        "usage" => "this is the usage",
        "marketing_message" => "this is the marketing message",
        "organisations_using_url" => "this is the organisations using the url",
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

    post :create, params: valid_short_url_request_params

    expect(stub_ticket_creation).to have_been_made
  end
end
