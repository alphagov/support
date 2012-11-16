require "test_helper"

class ContentChangeRequestsControllerTest < ActionController::TestCase
  include ZendeskOrganisationListHelper
  include TestData

  setup do
    login_as_stub_user
    @zendesk_api = ZenDeskAPIClientDouble.new
    ZendeskClient.stubs(:get_client).returns(@zendesk_api)
  end

  context "a new content change request" do
    should "render the form" do
      get :new
      assert_select "h1", /Request a change to existing GOV.UK content/i
    end

    should "use ZenDesk to populate the organisation dropdown" do
      get :new
      assert_select "select#organisation_list option", "Advocate General for Scotland"
    end

    should "inform the user if ZenDesk is unreachable" do
      @zendesk_api.should_raise_error

      get :new
      assert_template "support/zendesk_error"
    end
  end

  context "a submitted content change request" do
    should "reject invalid change requests" do
      params = valid_content_change_request_params.merge("organisation" => "")
      post :create, params
      assert_response 400
      assert_template "new"
      assert_select ".help-block", /Organisation information is required/
    end

    should "submit it to ZenDesk" do
      params = valid_content_change_request_params
      post :create, params

      assert_equal ['content_amend'], @zendesk_api.ticket.tags

      assert_redirected_to "/acknowledge"
    end

    context "concerning Inside Government" do
      should "tag the ticket with an inside_government tag" do
        params = valid_content_change_request_params.merge("inside_government" => "yes")

        post :create, params

        assert_includes @zendesk_api.ticket.tags, 'inside_government'

        assert_redirected_to "/acknowledge"
      end
    end
  end
end
