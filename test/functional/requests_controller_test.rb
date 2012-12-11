require 'test_helper'
require 'tableless_model'
require 'zendesk_ticket'

class TestRequest < TablelessModel
  include WithRequester

  attr_accessor :a, :b
  validates_presence_of :a
end

class TestZendeskTicket < ZendeskTicket
  def subject
    "Test request"
  end

  def tags
    ["tag_a", "tag_b"]
  end

  def comment_snippets
    []
  end
end

class TestRequestsController < RequestsController
  def new_request
    TestRequest.new(:requester => Requester.new)
  end

  def zendesk_ticket_class
    TestZendeskTicket
  end

  def parse_request_from_params
    TestRequest.new(params[:test_request])
  end
end

def valid_params_for_test_request
  {
    "test_request" => {
      "a" => "A string", "b" => "Another string",
      "requester_attributes" => {"email" => "abc@d.com"}
    }
  }
end

class RequestsControllerTest < ActionController::TestCase
  setup do
    login_as_stub_user
    @zendesk_api = ZenDeskAPIClientDouble.new
    ZendeskClient.stubs(:get_client).returns(@zendesk_api)

    Rails.application.routes.draw do
      match 'new' => "test_requests#new"
      match 'create' => "test_requests#create"
    end

    @controller = TestRequestsController.new
    prevent_implicit_rendering
  end

  teardown do
    Rails.application.reload_routes!
  end

  context "a new general request" do
    should "render the form" do
      @controller.expects(:default_render)
      get :new
    end
  end

  def prevent_implicit_rendering
    # we're not testing view rendering here,
    # so prevent rendering by stubbing out default_render
    @controller.stubs(:default_render)
  end

  context "a submission of a test request" do
    should "reject invalid parameters" do
      params = valid_params_for_test_request.tap {|p| p["test_request"].merge!("a" => "")}

      @controller.expects(:render).with(:new, has_entry(:status => 400))

      post :create, params
    end

    should "submit it to ZenDesk" do
      params = valid_params_for_test_request

      post :create, params

      assert_equal ['tag_a', 'tag_b'], @zendesk_api.ticket.tags
      assert_redirected_to "/acknowledge"
    end

    should "set collaborators if they're set on the request" do
      params = valid_params_for_test_request.tap do |p|
        p["test_request"]["requester_attributes"].merge!("collaborator_emails" => "ab@c.com, def@g.com")
      end

      post :create, params
      assert_equal ["ab@c.com", "def@g.com"], @zendesk_api.ticket.collaborators
    end
  end
end