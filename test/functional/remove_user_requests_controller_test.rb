require 'test_helper'

class RemoveUserRequestsControllerTest < ActionController::TestCase
  include TestData

  setup do
    login_as_stub_user
    @zendesk_api = ZenDeskAPIClientDouble.new
    ZendeskClient.stubs(:get_client).returns(@zendesk_api)
  end

  context "new remove user request" do
    should "render the form" do
      get :new
      assert_select "h1", /Remove User/i
    end
  end

  context "submitted remove user request" do
    should "reject invalid requests" do
      params = valid_remove_user_request_params.tap {|p| p["remove_user_request"]["requester_attributes"].merge!("email" => "")}
      post :create, params
      assert_response 400
      assert_template "new"
      assert_select ".help-inline", /can't be blank/
    end

    should "submit it to ZenDesk" do
      params = valid_remove_user_request_params

      post :create, params

      assert_equal ['remove_user'], @zendesk_api.ticket.tags
      assert_redirected_to "/acknowledge"
    end

    context "concerning Inside Government" do
      should "tag the ticket with an inside_government tag" do
        params = valid_remove_user_request_params.tap {|p| p["remove_user_request"].merge!("tool_role" => "inside_government_editor")}

        post :create, params

        assert_includes @zendesk_api.ticket.tags, 'inside_government'

        assert_redirected_to "/acknowledge"
      end
    end
  end
end
