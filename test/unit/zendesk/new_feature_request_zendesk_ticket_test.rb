require 'test/unit'
require 'shoulda/context'
require 'new_feature_request_zendesk_ticket'
require 'ostruct'

class NewFeatureRequestZendeskTicketTest < Test::Unit::TestCase
  def ticket_with(opts)
    NewFeatureRequestZendeskTicket.new(stub_everything("request", opts))
  end

  context "an inside government request" do
    should "be tagged with inside_government" do
      tags_on_ticket = ticket_with(:inside_government_related? => true).tags
      assert_includes tags_on_ticket, "new_feature_request"
      assert_includes tags_on_ticket, "inside_government"
    end

    should "have a subject" do
      assert_equal "New Feature Request", ticket_with(:inside_government_related? => true).subject
    end
  end

  context "a mainstream request" do
    should "be tagged with new_need_request" do
      tags_on_ticket = ticket_with(:inside_government_related? => false).tags
      assert_includes tags_on_ticket, "new_need_request"
    end

    should "have a subject" do
      assert_equal "New Need Request", ticket_with(:inside_government_related? => false).subject
    end
  end
end