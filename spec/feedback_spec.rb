require "rack/test"
require "test/unit"
require "mocha"
require_relative "../lib/app"
require_relative "../lib/zendesk_client"

class FeedbackSpec < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    App
  end

  def test_page_contain_required_fields
    #When
    get '/add-content'

    #Then
    assert last_response.body.include?('Name')
    assert last_response.body.include?('Email')
    assert last_response.body.include?('Job Title')
    assert last_response.body.include?('Phone Number')
    assert last_response.body.include?('Department')
  end

  def test_departments_list_shown_on_page
    #Given
    ZendeskClient.expects(:get_departments).returns([{"key1" => "value1"}, {"key2" => "value2"}])

    #When
    get '/add-content'

    #Then
    assert last_response.ok?
    assert last_response.body.include?("key1")
  end

end
