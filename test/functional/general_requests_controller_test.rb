require 'test_helper'

class GeneralRequestsControllerTest < ActionController::TestCase
  include ZendeskOrganisationListHelper
  include TestData

  setup do
    login_as_stub_user
    @zendesk_api = ZenDeskAPIClientDouble.new
    ZendeskClient.stubs(:get_client).returns(@zendesk_api)
  end

  context "a new general request" do
    setup do
      stub_zendesk_organisation_list
    end

    should "render the form" do
      get :new
      assert_select "h1", /Report a problem, request GDS support, or to make a suggestion/i
    end

    should "use ZenDesk to populate the organisation dropdown" do
      get :new
      assert_select "select#general_request_requester_attributes_organisation option", "Advocate General for Scotland"
    end
  end

  context "a submitted general request" do
    setup do
      stub_zendesk_organisation_list
    end

    should "reject invalid requests" do
      params = valid_general_request_params.tap {|p| p["general_request"]["requester_attributes"].merge!("email" => "")}

      post :create, params

      assert_response 400
      assert_template :new
      assert_select ".help-inline", /can't be blank/
    end

    should "submit it to ZenDesk" do
      params = valid_general_request_params

      post :create, params

      assert_equal ['govt_agency_general'], @zendesk_api.ticket.tags
      assert_redirected_to "/acknowledge"
    end

    should "add the user agent to the ticket in the comments" do
      request.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2)"
      params = valid_general_request_params

      post :create, params

      assert_includes @zendesk_api.ticket.comment, "Mozilla/5.0"
    end
  end
end