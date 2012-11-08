require 'ostruct'
require_relative "../test_helper"

class ContentChangeRequestsControllerTest < ActionController::TestCase
  include ZenDeskOrganisationListHelper
  include TestData

  setup do
    login_as_stub_user
    @zendesk_api = ZenDeskAPIClientDouble.new
    ZendeskClient.stubs(:get_client).returns(@zendesk_api)
  end

  context "a new content change request" do
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

  context "a submitted content change request" do
    should "reject invalid change requests" do
      params = valid_content_change_request_params.merge("organisation" => "")
      post :create, params
      assert_response 200 # should actually be an error status, but let's worry about that later
      assert_template "new"
      assert_select ".help-block", /Organisation information is required/
    end

    should "submit it to ZenDesk" do
      params = valid_content_change_request_params
      post :create, params

      assert_equal ['content_amend'], @zendesk_api.ticket.options[:tags]

      assert_redirected_to "/acknowledge"
    end

    context "concerning Inside Government" do
      should "submit it to ZenDesk" do
        params = valid_content_change_request_params.merge("inside_government" => "yes")

        post :create, params

        assert_equal ['content_amend', 'inside_government'], @zendesk_api.ticket.options[:tags]

        assert_redirected_to "/acknowledge"
      end
    end
  end
end
