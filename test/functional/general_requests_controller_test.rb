require 'test_helper'

class GeneralRequestsControllerTest < ActionController::TestCase
  include TestData

  context "a submitted general request" do
    should "add the user agent to the ticket in the comments" do
      request.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2)"
      stub_zendesk_ticket_creation_with_body(/Mozilla\/5.0/)

      post :create, valid_general_request_params
    end
  end
end
