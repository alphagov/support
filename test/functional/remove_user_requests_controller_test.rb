require 'test_helper'

class RemoveUserRequestsControllerTest < ActionController::TestCase
  include ZendeskOrganisationListHelper
  include TestData

  setup do
    login_as_stub_user
    @zendesk_api = ZenDeskAPIClientDouble.new
    ZendeskClient.stubs(:get_client).returns(@zendesk_api)
  end

  context "new remove user request" do
    setup do
      stub_zendesk_organisation_list
    end

    should "render the form" do
      get :new
      assert_select "h1", /Remove User/i
    end

    should "use ZenDesk to populate the organisation dropdown" do
      get :new
      assert_select "select#organisation_list option", "Advocate General for Scotland"
    end
  end

  context "submitted remove user request" do
    should "reject invalid requests" do
      params = valid_remove_user_request_params.merge("organisation" => "")
      post :create, params
      assert_response 400
      assert_template "new"
      assert_select ".help-block", /Organisation information is required/
    end

    should "submit it to ZenDesk" do
      params = valid_remove_user_request_params

      post :create, params

      assert_equal ['remove_user'], @zendesk_api.ticket.tags
      assert_redirected_to "/acknowledge"
    end

    context "concerning Inside Government" do
      should "tag the ticket with an inside_government tag" do
        params = valid_remove_user_request_params.merge("inside_government" => "yes")

        post :create, params

        assert_includes @zendesk_api.ticket.tags, 'inside_government'

        assert_redirected_to "/acknowledge"
      end
    end
  end
end
