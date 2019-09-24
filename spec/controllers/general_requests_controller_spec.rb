require "rails_helper"

describe GeneralRequestsController, type: :controller do
  def valid_general_request_params
    {
      "support_requests_general_request" => {
        "requester_attributes" => valid_requester_params,
        "url" => "testing",
        "details" => "something or other",
      },
    }
  end

  before do
    login_as create(:user)
    zendesk_has_no_user_with_email(@user.email)
  end

  context "a submitted general request" do
    it "adds the user agent to the ticket in the comments" do
      request.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2)"
      ticket_request = stub_zendesk_ticket_creation_with_body(/Mozilla\/5.0/)

      post :create, params: valid_general_request_params

      expect(ticket_request).to have_been_made
    end
  end
end
