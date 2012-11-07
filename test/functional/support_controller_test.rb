require_relative "../test_helper"

class SupportControllerTest < ActionController::TestCase
  include ZenDeskOrganisationListHelper

  setup do
    login_as_stub_user
  end

  context "GET landing" do
    should "render the homepage" do
      get :landing
      assert_select "h1", /Welcome to GOV.UK Support/i
    end
  end

  context "GET create_user" do
    setup do
      stub_zendesk_organisation_list
    end

    should "render the form" do
      get :create_user
      assert_select "h1", /Create a new user account/i
    end

    should "use ZenDesk to populate the organisation dropdown" do
      get :create_user
      assert_select "select#organisation_list option", "Advocate General for Scotland"
    end
  end

  context "POST create_user" do
    setup do
      stub_zendesk_organisation_list
    end

    should "reject invalid requests" do
      params = {
        "name"=>"Testing",
        "email"=>"testing@digital.cabinet-office.gov.uk",
        "job"=>"dev",
        "phone"=>"",
        "organisation"=>"", # organisation must be set
        "other_organisation"=>"",
        "user_name"=>"",
        "user_email"=>"",
        "additional"=>""
      }
      post :create_user, params
      assert_response 200 # should actually be an error status, but let's worry about that later
      assert_template "useraccess/user"
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
        "user_name"=>"subject",
        "user_email"=>"subject@digital.cabinet-office.gov.uk",
        "additional"=>""
      }
      ZendeskRequest.expects(:raise_zendesk_request).returns("not a null")
      post :create_user, params
      assert_redirected_to "/acknowledge"
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
      params = {
        "name"=>"Testing",
        "email"=>"testing@digital.cabinet-office.gov.uk",
        "job"=>"This is just a test",
        "phone"=>"",
        "organisation"=>"", # this has to be filled in
        "other_organisation"=>"",
        "user_name"=>"testing",
        "user_email"=>"ignore-me@foo.com",
        "not_before_day"=>"",
        "not_before_month"=>"",
        "not_before_year"=>"",
        "additional"=>""
      }
      post :remove_user, params
      assert_response 200 # should actually be an error status, but let's worry about that later
      assert_template "useraccess/user"
      assert_select ".help-block", /Organisation information is required/
    end

    should "submit it to ZenDesk" do
      params = {
        "name"=>"Testing",
        "email"=>"testing@digital.cabinet-office.gov.uk",
        "job"=>"This is just a test",
        "phone"=>"",
        "organisation"=>"cabinet_office",
        "other_organisation"=>"",
        "user_name"=>"testing",
        "user_email"=>"ignore-me@foo.com",
        "not_before_day"=>"",
        "not_before_month"=>"",
        "not_before_year"=>"",
        "additional"=>""
      }
      ZendeskRequest.expects(:raise_zendesk_request).returns("not a null")
      post :remove_user, params
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
      params = {
        "name"=>"Testing",
        "email"=>"testing@digital.cabinet-office.gov.uk",
        "job"=>"doo",
        "phone"=>"",
        "organisation"=>"",
        "other_organisation"=>"",
        "campaign_name"=>"Testing",
        "erg_number"=>"1234",
        "start_day"=>"",
        "start_month"=>"",
        "start_year"=>"",
        "description"=>"Testing",
        "company"=>"",
        "url"=>"",
        "additional"=>""
      }
      post :campaign, params
      assert_response 200 # should actually be an error status, but let's worry about that later
      assert_template "campaigns/campaign"
      assert_select ".help-block", /Organisation information is required/
    end

    should "submit it to ZenDesk" do
      params = {
        "name"=>"Testing",
        "email"=>"testing@digital.cabinet-office.gov.uk",
        "job"=>"doo",
        "phone"=>"",
        "organisation"=>"cabinet_office",
        "other_organisation"=>"",
        "campaign_name"=>"Testing",
        "erg_number"=>"1234",
        "start_day"=>"",
        "start_month"=>"",
        "start_year"=>"",
        "description"=>"Testing",
        "company"=>"",
        "url"=>"",
        "additional"=>""
      }
      ZendeskRequest.expects(:raise_zendesk_request).returns("not a null")
      post :campaign, params
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
      post :general, params
      assert_response 200 # should actually be an error status, but let's worry about that later
      assert_template "tech-issues/general"
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
      post :general, params
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
