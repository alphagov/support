require 'test_helper'

class GeneralRequestsControllerTest < ActionController::TestCase
  include TestData

  setup do
    login_as_stub_user
    @zendesk_api = ZenDeskAPIClientDouble.new
    ZendeskClient.stubs(:get_client).returns(@zendesk_api)
  end

  context "a submitted general request" do
    should "add the user agent to the ticket in the comments" do
      request.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2)"
      params = valid_general_request_params

      post :create, params

      assert_includes @zendesk_api.ticket.comment, "Mozilla/5.0"
    end
  end
end