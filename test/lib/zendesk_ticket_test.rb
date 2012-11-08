require 'test/unit'
require 'shoulda/context'
require 'zendesk_ticket'
require 'test_data'

class ZendeskTicketTest < Test::Unit::TestCase
  context "content change request" do
    should "set the tags correctly for valid tickets" do
      ticket = ZendeskTicket.new(VALID_CONTENT_CHANGE_REQUEST_PARAMS, "amend-content")
      assert ['content_amend'], ticket.tag
    end
  end
end