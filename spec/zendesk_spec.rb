require "test/unit"
require "rack/test"
require_relative "../lib/zendesk_client.rb"

class ZendeskTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def test_should_be_able_to_read_username_password_from_file
    #When
    details = ZendeskClient.get_username_password

    #Then
    assert_equal("zd-api-govt@digital.cabinet-office.gov.uk", details[0])
    assert_equal("12345", details[1])
  end
end