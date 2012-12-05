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

  def new
    super
    render :text => "<h1>new form</h1>"
  end

  def rerender_form_with_invalid_request
    render :text => "<h1>your submission was invalid</h1>", :status => 400
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
  end

  teardown do
    Rails.application.reload_routes!
  end

  context "a new general request" do
    should "render the form" do
      get :new
      assert_select "h1", "new form"
    end
  end

  context "a submission of a test request" do
    should "reject invalid parameters" do
      params = valid_params_for_test_request.tap {|p| p["test_request"].merge!("a" => "")}

      post :create, params

      assert_response 400
      assert_select "h1", "your submission was invalid"
    end

    should "submit it to ZenDesk" do
      params = valid_params_for_test_request

      post :create, params

      assert_equal ['tag_a', 'tag_b'], @zendesk_api.ticket.tags
      assert_redirected_to "/acknowledge"
    end
  end
end