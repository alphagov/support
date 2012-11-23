require 'test/unit'
require 'shoulda/context'
require 'create_new_user_request_zendesk_ticket'
require 'ostruct'

class CreateNewUserRequestZendeskTicketTest < Test::Unit::TestCase
  def ticket_with(opts)
    CreateNewUserRequestZendeskTicket.new(stub_everything("request", opts))
  end

  context "an inside government request" do
    should "be tagged with inside_government" do
      assert_equal ["new_user", "inside_government"], ticket_with(:inside_government_related? => true).tags
    end
  end
end