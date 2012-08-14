require "rack/test"
require "test/unit"
require "mocha"
require_relative "../lib/app"
require_relative "../lib/zendesk_helper"

class FeedbackSpec < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    App
  end

  def test_page_contain_required_fields
    get '/feedback'
    assert last_response.body.include?( 'Name')
    assert last_response.body.include?('Email')
    assert last_response.body.include?('Job Title')
    assert last_response.body.include?('Phone Number')
    assert last_response.body.include?('Department')
  end

  def test_departments_list_shown_on_page
    ZendeskHelper.expects(:get_departments).returns([{"key1" => "value1"}, {"key2" => "value2"}])

    get '/feedback'
    assert last_response.ok?
    assert last_response.body.include?("key1")
  end


end