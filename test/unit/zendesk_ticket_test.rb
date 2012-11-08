require 'test/unit'
require 'shoulda/context'
require 'zendesk_ticket'
require 'test_data'

class ZendeskTicketTest < Test::Unit::TestCase
  include TestData
  context "content change request" do
    should "set the tags correctly for valid tickets" do
      ticket = ZendeskTicket.new(valid_content_change_request_params, "amend-content")
      assert_equal ['content_amend'], ticket.tags
    end

    should "set the tags correctly for valid inside govt tickets" do
      ticket = ZendeskTicket.new(valid_content_change_request_params.merge(:inside_government => "yes"), "amend-content")
      assert_equal ['content_amend', 'inside_government'], ticket.tags
    end
  end
end