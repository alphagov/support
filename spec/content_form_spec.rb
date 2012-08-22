require "rack/test"
require "test/unit"
require "mocha"
require_relative "../lib/app"
require_relative "../lib/zendesk_client"

class ContentFormSpec < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    App
  end

  #def setup
  #  @browser ||= Rack::Test::Session.new(Rack::MockSession.new(App))
  #end

  def teardown
    Mocha::Mockery.instance.teardown
    Mocha::Mockery.reset_instance
  end

  def test_page_contain_required_fields
    #When
    get '/add-content'

    #Then
    assert last_response.body.include?('Name')
    assert last_response.body.include?('Email')
    assert last_response.body.include?('Job title')
    assert last_response.body.include?('Phone number')
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

  def  test_zendesk_create_ticket_triggered_by_post_request
    ZendeskClient.expects(:raise_zendesk_request)

    #When
    post '/add-content', fill_content_form()
    follow_redirect!

    #Then
    assert last_response.ok?
    assert last_request.url, '/acknowledge'
  end

  def fill_content_form
    {:target_url => '/temp',
     :add_content => 'test content to add',
     :additional => 'additional message',
     :need_by_day => '30',
     :need_by_month =>'12',
     :need_by_year => '2012',
     :not_before_day => '31',
     :not_before_month => '12',
     :not_before_year => '2012',
     :name => 'tester',
     :email => 'yu.fu@digital.cabinet-office.gov.uk',
     :department => 'test department',
     :job => 'job',
     :phone => '123456'
    }
  end
end
