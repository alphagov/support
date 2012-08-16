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
    #When
    get '/new'

    #Then
    assert last_response.body.include?('Name')
    assert last_response.body.include?('Email')
    assert last_response.body.include?('Job Title')
    assert last_response.body.include?('Phone Number')
    assert last_response.body.include?('Department')
  end

  def test_departments_list_shown_on_page
    #Given
    ZendeskHelper.expects(:get_departments).returns([{"key1" => "value1"}, {"key2" => "value2"}])

    #When
    get '/new'

    #Then
    assert last_response.ok?
    assert last_response.body.include?("key1")
  end

  def xtest_after_form_submitted_redirect_to_acknowledge_page

    ZendeskHelper.expects(:raise_zendesk_request).once
    post '/new'
    puts last_response.ok?
    #puts last_response.body

  end


end
