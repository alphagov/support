require "test_helper"

class SupportControllerTest < ActionController::TestCase
  setup do
    login_as_stub_user
    @zendesk_api = ZenDeskAPIClientDouble.new
    ZendeskClient.stubs(:get_client).returns(@zendesk_api)
  end

  context "GET landing" do
    should "render the homepage" do
      get :landing
      assert_select "h1", /Welcome to GOV.UK Support/i
    end
  end
end
