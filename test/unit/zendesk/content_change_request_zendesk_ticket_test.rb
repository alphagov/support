require 'test/unit'
require 'shoulda/context'
require 'content_change_request_zendesk_ticket'
require 'ostruct'

class ContentChangeRequestZendeskTicketTest < Test::Unit::TestCase
  def ticket_with(opts)
    ContentChangeRequestZendeskTicket.new(stub_everything("request", opts))
  end

  context "an inside government request" do
    should "be tagged with inside_government" do
      assert_equal ["content_amend", "inside_government"], ticket_with(:inside_government_related? => true).tags
    end
  end
end