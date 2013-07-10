require "test_helper"
require 'zendesk_api/error'

class CreateOrChangeUserRequestsControllerTest < ActionController::TestCase
  include TestData

  context "submitted user creation request" do
    should "submit it to ZenDesk" do
      post :create, valid_create_or_change_user_request_params

      assert_equal ['govt_form', 'create_new_user'], @zendesk_api.ticket.tags
      assert_redirected_to "/acknowledge"
    end

    should "create a Zendesk user with the requested user details" do
      post :create, valid_create_or_change_user_request_params

      expected_created_user_attributes = {
        email: "subject@digital.cabinet-office.gov.uk",
        name: "subject",
        details: "Job title: editor",
        phone: "12345",
        verified: true
      }
      assert_equal expected_created_user_attributes, @zendesk_api.users.created_user_attributes
    end

    should "not expose an error to the user when automatic user creation goes wrong" do
      @zendesk_api.users.should_raise_error

      ExceptionNotifier::Notifier.expects(:exception_notification)
                                 .with(anything, kind_of(ZendeskAPI::Error::ClientError), anything)
                                 .returns(stub("mailer", deliver: true))

      post :create, valid_create_or_change_user_request_params

      assert_redirected_to "/acknowledge"
    end

    context "concerning Inside Government" do
      should "tag the ticket with an inside_government tag" do
        params = valid_create_or_change_user_request_params.tap {|p| p["support_requests_create_or_change_user_request"].merge!("tool_role" => "inside_government_editor")}

        post :create, params

        assert_includes @zendesk_api.ticket.tags, 'inside_government'

        assert_redirected_to "/acknowledge"
      end
    end
  end
end
