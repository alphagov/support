require "test_helper"

class SupportControllerTest < ActionController::TestCase
  include ZendeskOrganisationListHelper
  include TestData

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

  context "GET campaign" do
    setup do
      stub_zendesk_organisation_list
    end

    should "render the form" do
      get :campaign
      assert_select "h1", /Campaign/i
    end

    should "use ZenDesk to populate the organisation dropdown" do
      get :campaign
      assert_select "select#organisation_list option", "Advocate General for Scotland"
    end
  end

  context "POST campaign" do
    setup do
      stub_zendesk_organisation_list
    end

    should "reject invalid requests" do
      params = valid_campaign_request_params.merge("organisation" => "")
      post :campaign, params
      assert_response 400
      assert_template "campaigns/campaign"
      assert_select ".help-block", /Organisation information is required/
    end

    should "submit it to ZenDesk" do
      params = valid_campaign_request_params

      post :campaign, params

      assert_equal ['campaign'], @zendesk_api.ticket.tags
      assert_redirected_to "/acknowledge"
    end
  end
end
