require "test_helper"

class SupportControllerTest < ActionController::TestCase
  include ZenDeskOrganisationListHelper
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

  context "GET remove_user" do
    setup do
      stub_zendesk_organisation_list
    end

    should "render the form" do
      get :remove_user
      assert_select "h1", /Remove User/i
    end

    should "use ZenDesk to populate the organisation dropdown" do
      get :remove_user
      assert_select "select#organisation_list option", "Advocate General for Scotland"
    end
  end

  context "POST remove_user" do
    setup do
      stub_zendesk_organisation_list
    end

    should "reject invalid requests" do
      params = valid_remove_user_request_params.merge("organisation" => "")
      post :remove_user, params
      assert_response 200 # should actually be an error status, but let's worry about that later
      assert_template "useraccess/user"
      assert_select ".help-block", /Organisation information is required/
    end

    should "submit it to ZenDesk" do
      params = valid_remove_user_request_params

      post :remove_user, params

      assert_equal ['remove_user'], @zendesk_api.ticket.options[:tags]
      assert_redirected_to "/acknowledge"
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
      assert_response 200 # should actually be an error status, but let's worry about that later
      assert_template "campaigns/campaign"
      assert_select ".help-block", /Organisation information is required/
    end

    should "submit it to ZenDesk" do
      params = valid_campaign_request_params

      post :campaign, params

      assert_equal ['campaign'], @zendesk_api.ticket.options[:tags]
      assert_redirected_to "/acknowledge"
    end
  end

  context "GET general" do
    setup do
      stub_zendesk_organisation_list
    end

    should "render the form" do
      get :general
      assert_select "h1", /Report a problem, request GDS support, or to make a suggestion/i
    end

    should "use ZenDesk to populate the organisation dropdown" do
      get :general
      assert_select "select#organisation_list option", "Advocate General for Scotland"
    end
  end

  context "POST general" do
    setup do
      stub_zendesk_organisation_list
    end

    should "reject invalid requests" do
      params = valid_general_request_params.merge("organisation" => "")
      post :general, params
      assert_response 200 # should actually be an error status, but let's worry about that later
      assert_template "tech-issues/general"
      assert_select ".help-block", /Organisation information is required/
    end

    should "submit it to ZenDesk" do
      params = valid_general_request_params

      post :general, params

      assert_equal ['govt_agency_general'], @zendesk_api.ticket.options[:tags]
      assert_redirected_to "/acknowledge"
    end
  end

  context "GET publish_tool" do
    setup do
      stub_zendesk_organisation_list
    end

    should "render the form" do
      get :publish_tool
      assert_select "h1", /Publishing Tool/i
    end

    should "use ZenDesk to populate the organisation dropdown" do
      get :publish_tool
      assert_select "select#organisation_list option", "Advocate General for Scotland"
    end
  end

  context "POST publish_tool" do
    setup do
      stub_zendesk_organisation_list
    end

    should "reject invalid requests" do
      params = {
        "name"=>"Testing",
        "email"=>"testing@digital.cabinet-office.gov.uk",
        "job"=>"dev",
        "phone"=>"",
        "organisation"=>"",
        "other_organisation"=>"",
        "url"=>"testing",
        "additional"=>""
      }
      post :publish_tool, params
      assert_response 200 # should actually be an error status, but let's worry about that later
      assert_template "tech-issues/publish_tool"
      assert_select ".help-block", /Organisation information is required/
    end

    should "submit it to ZenDesk" do
      params = {
        "name"=>"Testing",
        "email"=>"testing@digital.cabinet-office.gov.uk",
        "job"=>"dev",
        "phone"=>"",
        "organisation"=>"cabinet_office",
        "other_organisation"=>"",
        "url"=>"testing",
        "additional"=>""
      }
      ZendeskRequest.expects(:raise_zendesk_request).returns("not a null")
      post :publish_tool, params
      assert_redirected_to "/acknowledge"
    end
  end
end
