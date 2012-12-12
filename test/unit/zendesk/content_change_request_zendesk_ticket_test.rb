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
      tags_on_ticket = ticket_with(:inside_government_related? => true).tags
      assert_includes tags_on_ticket, "content_amend"
      assert_includes tags_on_ticket, "inside_government"
    end
  end
end