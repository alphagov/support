require "test/unit"
require "rack/test"
require_relative "../lib/zendesk_client.rb"

class ZendeskTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def test_should_be_able_to_read_username_password_from_file
    #Given
    #expected_name = "username"
    #expected_pass = "password"
    file = YAML.load_file(File.open('./config/zendesk.yml'))
    #file = YamlEquivalent.

    #When
    details = ZendeskClient.get_username_password(file)

    #Then
    assert_equal("zd-api-govt@digital.cabinet-office.gov.uk", details[0])
    #assert_equal("12345", details[1])
    #assert_equal(expected_name, details[0])
  end
end