require "test_helper"

class CreateNewUserRequestsControllerTest < ActionController::TestCase
  include ZenDeskOrganisationListHelper
  include TestData

  setup do
    login_as_stub_user
    @zendesk_api = ZenDeskAPIClientDouble.new
    ZendeskClient.stubs(:get_client).returns(@zendesk_api)
  end

  context "GET create_user" do
    setup do
      stub_zendesk_organisation_list
    end

    should "render the form" do
      get :new
      assert_select "h1", /Create a new user account/i
    end

    should "use ZenDesk to populate the organisation dropdown" do
      get :new
      assert_select "select#organisation_list option", "Advocate General for Scotland"
    end
  end

  context "POST create_user" do
    should "reject invalid requests" do
      params = valid_create_new_user_request_params.merge("organisation" => "")
      post :create, params
      assert_response 200 # should actually be an error status, but let's worry about that later
      assert_template "new"
      assert_select ".help-block", /Organisation information is required/
    end

    should "submit it to ZenDesk" do
      params = valid_create_new_user_request_params

      post :create, params

      assert_equal ['new_user'], @zendesk_api.ticket.options[:tags]
      assert_redirected_to "/acknowledge"
    end
  end
end
