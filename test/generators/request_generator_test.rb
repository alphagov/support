require "test_helper"
require 'generators/request/request_generator'

class RequestGeneratorTest < Rails::Generators::TestCase
  tests RequestGenerator
  destination File.expand_path("../../tmp", __FILE__)

  setup :prepare_destination
  teardown :remove_temp_files

  setup do
    run_generator %w{ my_thing_request }    
  end

  test 'model files are created' do
    assert_file 'lib/support/requests/my_thing_request.rb',
      /My thing/,
      /class MyThingRequest/

    assert_file 'test/unit/support/requests/my_thing_request_test.rb', /MyThingRequestTest/
  end

  test 'controller created' do
    assert_file 'app/controllers/my_thing_requests_controller.rb',
      /class MyThingRequestsController/
  end

  test 'zendesk ticket model file created' do
    assert_file 'lib/zendesk/ticket/my_thing_request_ticket.rb',
      /class MyThingRequestTicket/
  end

  test 'view templates created' do
    assert_file 'app/views/my_thing_requests/new.html.erb', /My Thing/
    assert_file 'app/views/my_thing_requests/_request_details.html.erb'
  end

  test 'cucumber code created' do
    assert_file 'features/my_thing_requests.feature', /Feature: My thing requests/
    assert_file 'features/step_definitions/my_thing_requests_steps.rb'
  end

  def remove_temp_files
    rm_rf destination_root
  end
end
