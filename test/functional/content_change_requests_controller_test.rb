require 'ostruct'
require_relative "../test_helper"

class ContentChangeRequestsControllerTest < ActionController::TestCase
  include ZenDeskOrganisationListHelper

  setup do
    login_as_stub_user
    @zendesk_api = ZenDeskAPIClientDouble.new
    ZendeskClient.stubs(:get_client).returns(@zendesk_api)
  end

  VALID_CONTENT_CHANGE_REQUEST_PARAMS = {
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
    should "reject invalid change requests" do
      params = VALID_CONTENT_CHANGE_REQUEST_PARAMS.merge("organisation" => "")
      post :create, params
      assert_response 200 # should actually be an error status, but let's worry about that later
      assert_template "new"
      assert_select ".help-block", /Organisation information is required/
    end

    should "submit it to ZenDesk" do
      params = VALID_CONTENT_CHANGE_REQUEST_PARAMS
      post :create, params

      assert_equal ['content_amend'], @zendesk_api.ticket.options[:tags]

      assert_redirected_to "/acknowledge"
    end
  end
end
