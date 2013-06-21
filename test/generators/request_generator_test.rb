require "test_helper"
require 'generators/request/request_generator'

class RequestGeneratorTest < Rails::Generators::TestCase
  tests RequestGenerator
  destination File.expand_path("../../tmp", __FILE__)

  setup :prepare_destination
  teardown :remove_temp_files

  test 'all files are properly created' do
    run_generator %w{ my_thing }
    assert_file 'lib/support/requests/my_thing_request.rb', /My thing/
    assert_file 'lib/support/requests/my_thing_request.rb', /class MyThingRequest/
    assert_file 'test/unit/support/requests/my_thing_request_test.rb', /MyThingRequestTest/
  end

  def remove_temp_files
    rm_rf destination_root
  end
end