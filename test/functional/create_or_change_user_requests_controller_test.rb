require "test_helper"
require 'zendesk_api/error'

class CreateOrChangeUserRequestsControllerTest < ActionController::TestCase
  include TestData

  context "submitted user creation request" do
    should "submit it to Zendesk and create a Zendesk user with the requested user details" do
      expected_created_user_attributes = {
        email: "subject@digital.cabinet-office.gov.uk",
        name: "subject",
        details: "Job title: editor",
        phone: "12345",
        verified: true
      }

      zendesk_has_no_user_with_email(valid_requested_user_params["email"])
      stub_ticket_creation = stub_zendesk_ticket_creation(hash_including(tags: ['govt_form', 'create_new_user']))
      stub_user_creation = stub_zendesk_user_creation(expected_created_user_attributes)

      post :create, valid_create_user_request_params

      assert_redirected_to "/acknowledge"
      assert_requested stub_ticket_creation
      assert_requested stub_user_creation
    end

    should "not make any changes to the Zendesk user for change user requests" do
      stub = stub_zendesk_ticket_creation

      post :create, valid_change_user_request_params

      assert_redirected_to "/acknowledge"
      assert_requested stub
    end

    should "not expose an error to the user when automatic user creation goes wrong" do
      zendesk_is_unavailable

      ExceptionNotifier::Notifier.expects(:exception_notification)
                                 .with(anything, kind_of(ZendeskAPI::Error::ClientError), anything)
                                 .returns(stub("mailer", deliver: true))

      post :create, valid_create_user_request_params

      assert_redirected_to "/acknowledge"
    end

    context "concerning Inside Government" do
      should "tag the ticket with an inside_government tag" do
        stub_request = stub_zendesk_ticket_creation(hash_including(tags: ['govt_form', 'change_user', 'inside_government']))
        params = valid_change_user_request_params.tap {|p| p["support_requests_create_or_change_user_request"].merge!("user_needs" => ["inside_government_editor"])}

        post :create, params

        assert_redirected_to "/acknowledge"
        assert_requested stub_request
      end
    end
  end
end
