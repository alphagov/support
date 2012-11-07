require_relative "../test_helper"

class ContentChangeRequestsControllerTest < ActionController::TestCase
  include ZenDeskOrganisationListHelper

  setup do
    login_as_stub_user
  end

  context "GET amend_content" do
    setup do
      stub_zendesk_organisation_list
    end

    should "render the form" do
      get :new
      assert_select "h1", /Request a change to existing GOV.UK content/i
    end

    should "use ZenDesk to populate the organisation dropdown" do
      get :new
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
      post :create, params
      assert_response 200 # should actually be an error status, but let's worry about that later
      assert_template "new"
      assert_select ".help-block", /Organisation information is required/
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
      post :create, params
      assert_redirected_to "/acknowledge"
    end
  end
end
