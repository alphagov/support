require "test/unit"
require "rack/test"
require_relative "../app/app"
require "mocha"

class TestGovFormPage < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_page_contain_required_fields
    get '/form'
    assert_include last_response.body, 'Name'
    assert_include last_response.body, 'Email'
    assert_include last_response.body, 'Job Title'
    assert_include last_response.body, 'Phone Number'
    assert_include last_response.body, 'Department'
  end

  def test_departments_list_shown_on_page
    ZendeskHelper.expects(:get_departments).returns([{"key1" => "value1"}, {"key2" => "value2"}])

    get '/form'
    assert last_response.ok?
    assert_include last_response.body, "key1"
  end

end