require "rack/test"
require "test/unit"
require "mocha"
require_relative "../lib/app"
require_relative "../lib/zendesk_request"
require_relative "../spec/page_helper"


class ContentFormSpec < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    App
  end

  def setup
    ZendeskClient.expects(:get_client)
  end

  def teardown
    Mocha::Mockery.instance.teardown
    Mocha::Mockery.reset_instance
  end

  def test_page_contain_required_fields
    #Given
    ZendeskRequest.expects(:get_departments).returns([{"key1" => "value1"}, {"key2" => "value2"}])

    #When
    get '/amend-content'

    #Then
    assert last_response.body.include?('Name')
    assert last_response.body.include?('Email')
    assert last_response.body.include?('Job title')
    assert last_response.body.include?('Phone number')
    assert last_response.body.include?('Department')
  end

  def test_departments_list_shown_on_page
    #Given
    ZendeskRequest.expects(:get_departments).returns([{"key1" => "value1"}, {"key2" => "value2"}])

    #When
    get '/amend-content'

    #Then
    assert last_response.ok?
    assert last_response.body.include?("key1")
  end

  def  test_zendesk_create_ticket_triggered_by_post_request
    form_parameters = PageHelper.fill_content_form
    ZendeskRequest.expects(:get_departments).returns([{"key1" => "value1"}, {"key2" => "value2"}])
    Guard.expects(:validationsForCreateUser).returns({});
    ZendeskRequest.expects(:raise_zendesk_request).returns("fake ticket")

    #When
    post '/create-user', form_parameters
    ZendeskClient.expects(:get_client)
    follow_redirect!

    #Then
    assert last_response.ok?, "the page is not successfully landed"
    assert last_request.url, '/acknowledge'
  end

end
