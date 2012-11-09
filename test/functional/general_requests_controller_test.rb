require 'test_helper'

class GeneralRequestsControllerTest < ActionController::TestCase
  include ZenDeskOrganisationListHelper
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
      assert_select "select#organisation_list option", "Advocate General for Scotland"
    end
  end

  context "a submitted general request" do
    setup do
      stub_zendesk_organisation_list
    end

    should "reject invalid requests" do
      params = valid_general_request_params.merge("organisation" => "")
      post :create, params
      assert_response 400
      assert_template :new
      assert_select ".help-block", /Organisation information is required/
    end

    should "submit it to ZenDesk" do
      params = valid_general_request_params

      post :create, params

      assert_equal ['govt_agency_general'], @zendesk_api.ticket.options[:tags]
      assert_redirected_to "/acknowledge"
    end
  end
end