require_relative "../test_helper"

class SupportControllerTest < ActionController::TestCase
  setup do
    login_as_stub_user
  end

  def stub_zendesk_organisation_list
    url = %r{https://.*@govuk.zendesk.com/api/v2/ticket_fields/21494928}
    body = {
      "ticket_field" => {
        "url" => "https://govuk.zendesk.com/api/v2/ticket_fields/21494928.json",
        "id"=>21494928,
        "type"=>"tagger",
        "title"=>"Department",
        "description"=>"",
        "position"=>9999,
        "active"=>true,
        "required"=>false,
        "collapsed_for_agents"=>false,
        "regexp_for_validation"=>nil,
        "title_in_portal"=>"Department",
        "visible_in_portal"=>false,
        "editable_in_portal"=>false,
        "required_in_portal"=>false,
        "tag"=>nil,
        "created_at"=>"2012-08-07 08:06:33 UTC",
        "updated_at"=>"2012-08-07 08:06:33 UTC",
        "custom_field_options"=>[
          {"name"=>"Advocate General for Scotland", "value"=>"advocate_general_for_scotland"},
          {"name"=>"Attorney General's Office", "value"=>"attorney_generals_office"},
          {"name"=>"Cabinet Office", "value"=>"cabinet_office"}
        ]
      }
    }

    stub_request(:get, url).
      to_return(:status => 200, :body => body.to_json, :headers => {"Content-Type" => "application/json"})
  end

  context "GET landing" do
    should "render the homepage" do
      get :landing
      assert_select "h1", /Welcome to GovUK Support/i
    end
  end

  context "GET amend_content" do
    setup do
      stub_zendesk_organisation_list
    end

    should "render the form" do
      get :amend_content
      assert_select "h1", /Content Change/i
    end

    should "use ZenDesk to populate the organisation dropdown" do
      get :amend_content
      assert_select "select#organisation_list option", "Advocate General for Scotland"
    end
  end

  context "POST amend_content" do
    setup do
      stub_zendesk_organisation_list
    end

    should "reject invalid change requests" do
      params = {
        "name"=>"Testing",
        "email"=>"testing@digital.cabinet-office.gov.uk",
        "job"=>"Dev",
        "organisation"=>"", # this has to be set
        "other_organisation"=>"",
        "url1"=>"",
        "url2"=>"",
        "url3"=>"",
        "add_content"=>"",
        "need_by_day"=>"",
        "need_by_month"=>"",
        "need_by_year"=>"",
        "not_before_day"=>"",
        "not_before_month"=>"",
        "not_before_year"=>"",
        "additional"=>""
      }
      post :amend_content, params
      assert_response 200 # should actually be an error status, but let's worry about that later
      assert_template "amend"
      assert_select ".errors", /Organisation information is required/
    end

    should "submit it to ZenDesk" do
      params = {
        "name"=>"Testing",
        "email"=>"testing@digital.cabinet-office.gov.uk",
        "job"=>"Dev",
        "phone"=>"",
        "organisation"=>"cabinet_office",
        "other_organisation"=>"",
        "url1"=>"",
        "url2"=>"",
        "url3"=>"",
        "add_content"=>"",
        "need_by_day"=>"",
        "need_by_month"=>"",
        "need_by_year"=>"",
        "not_before_day"=>"",
        "not_before_month"=>"",
        "not_before_year"=>"",
        "additional"=>""
      }
      ZendeskRequest.expects(:raise_zendesk_request).returns("not a null")
      post :amend_content, params
      assert_redirected_to "/acknowledge"
    end
  end

  context "GET create_user" do
    setup do
      stub_zendesk_organisation_list
    end

    should "render the form" do
      get :create_user
      assert_select "h1", /Create New User/i
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
      assert_select ".errors", /Organisation information is required/
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
      assert_select ".errors", /Organisation information is required/
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
      assert_select ".errors", /Organisation information is required/
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
      assert_select "h1", /General/i
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
      assert_select ".errors", /Organisation information is required/
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
      assert_select ".errors", /Organisation information is required/
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
