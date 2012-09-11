require "test/unit"
require "rack/test"
require_relative "../lib/zendesk_client.rb"

class ZendeskTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def test_should_be_able_to_read_username_password_from_file
    #Given
    expected_name = "username"
    expected_pass = "password"
    file =  {"development" => {"username" => expected_name, "password" => expected_pass}}

    #When
    details = ZendeskClient.get_username_password(file)

    #Then
    assert_equal(expected_name, details[0])
    assert_equal(expected_pass, details[1])
  end
end