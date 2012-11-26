require "test_helper"

class CreateNewUserRequestsControllerTest < ActionController::TestCase
  include ZendeskOrganisationListHelper
  include TestData

  setup do
    login_as_stub_user
    @zendesk_api = ZenDeskAPIClientDouble.new
    ZendeskClient.stubs(:get_client).returns(@zendesk_api)
  end

  context "new user creation request" do
    setup do
      stub_zendesk_organisation_list
    end

    should "render the form" do
      get :new
      assert_select "h1", /Create a new user account/i
    end

    should "use ZenDesk to populate the organisation dropdown" do
      get :new
      assert_select "select#create_new_user_request_requester_attributes_organisation option", "Advocate General for Scotland"
    end
  end

  context "submitted user creation request" do
    should "reject invalid requests" do
      params = valid_create_new_user_request_params.tap {|p| p["create_new_user_request"]["requester_attributes"].merge!("organisation" => "")}
      post :create, params
      assert_response 400
      assert_template "new"
      assert_select ".help-inline", /information is required/
    end

    should "submit it to ZenDesk" do
      params = valid_create_new_user_request_params

      post :create, params

      assert_equal ['new_user'], @zendesk_api.ticket.tags
      assert_redirected_to "/acknowledge"
    end

    context "concerning Inside Government" do
      should "tag the ticket with an inside_government tag" do
        params = valid_create_new_user_request_params.tap {|p| p["create_new_user_request"].merge!("inside_government" => "yes")}

        post :create, params

        assert_includes @zendesk_api.ticket.tags, 'inside_government'

        assert_redirected_to "/acknowledge"
      end
    end
  end
end
