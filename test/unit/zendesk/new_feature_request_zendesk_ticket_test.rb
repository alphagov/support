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
      assert_equal ["new_feature_request", "inside_government"], ticket_with(:inside_government_related? => true).tags
    end
  end
end