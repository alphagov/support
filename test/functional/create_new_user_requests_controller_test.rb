require "test_helper"

class CreateNewUserRequestsControllerTest < ActionController::TestCase
  include TestData

  setup do
    login_as_stub_user
    @zendesk_api = ZenDeskAPIClientDouble.new
    ZendeskClient.stubs(:get_client).returns(@zendesk_api)
  end

  context "submitted user creation request" do
    should "submit it to ZenDesk" do
      params = valid_create_new_user_request_params

      post :create, params

      assert_equal ['new_user'], @zendesk_api.ticket.tags
      assert_redirected_to "/acknowledge"

      expected_created_user_attributes = {
        email: "subject@digital.cabinet-office.gov.uk",
        name: "subject",
        details: "Job title: editor",
        phone: "12345",
        verified: true
      }
      assert_equal expected_created_user_attributes, @zendesk_api.users.created_user_attributes
    end

    context "concerning Inside Government" do
      should "tag the ticket with an inside_government tag" do
        params = valid_create_new_user_request_params.tap {|p| p["create_new_user_request"].merge!("tool_role" => "inside_government_editor")}

        post :create, params

        assert_includes @zendesk_api.ticket.tags, 'inside_government'

        assert_redirected_to "/acknowledge"
      end
    end
  end
end
