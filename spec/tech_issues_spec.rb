require "rack/test"
require "test/unit"
require "mocha"
require_relative "../lib/app"
require_relative "../lib/zendesk_client"
require_relative "../spec/page_helper"
require_relative "../lib/validations"

class TechnicalIssuesTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    App
  end

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    ZendeskRequest.expects(:get_organisations).returns([{"key1" => "value1"}, {"key2" => "value2"}])
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_get_request
    get '/general'
    assert last_response.ok?
    assert last_response.body.include?("General")
  end

  def test_create_zendesk_ticket_triggered_by_post_request
    filled_details = PageHelper.fill_content_form
    Guard.expects(:validationsForGeneralIssues).returns({})
    ZendeskRequest.expects(:raise_zendesk_request)

    post '/general', filled_details
  end

  def test_get_request_for_publishing_tool
    get '/publish-tool'

    assert last_response.ok?, "failed response."
    assert last_response.body.include?("Publishing Tool"), "Page does not contain header Publishing Tool"
  end

  def test_redirect_to_acknowledge_page_after_post_request
    filled_details = PageHelper.fill_content_form
    Guard.expects(:validationsForGeneralIssues).returns({})
    ZendeskRequest.expects(:raise_zendesk_request).returns("fake ticket")

    post '/general', filled_details
    follow_redirect!

    assert last_response.ok?
    assert last_request.url.include?('/acknowledge')

  end
end