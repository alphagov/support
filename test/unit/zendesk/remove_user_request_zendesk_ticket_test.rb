require 'test/unit'
require 'shoulda/context'
require 'remove_user_request_zendesk_ticket'
require 'ostruct'

class RemoveUserRequestZendeskTicketTest < Test::Unit::TestCase
  def ticket_with(opts)
    RemoveUserRequestZendeskTicket.new(stub_everything("request", opts))
  end

  context "an inside government request" do
    should "be tagged with inside_government" do
      assert_equal ["remove_user", "inside_government"], ticket_with(:inside_government_related? => true).tags
    end
  end
end