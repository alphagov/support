require 'test/unit'
require 'shoulda/context'
require 'zendesk/ticket/create_new_user_request_ticket'
require 'ostruct'

module Zendesk
  module Ticket
    class CreateNewUserRequestTest < Test::Unit::TestCase
      def ticket_with(opts)
        CreateNewUserRequestTicket.new(stub_everything("request", opts))
      end

      context "an inside government request" do
        should "be tagged with inside_government" do
          tags_on_ticket = ticket_with(:inside_government_related? => true).tags
          assert_includes tags_on_ticket, "new_user"
          assert_includes tags_on_ticket, "inside_government"
        end
      end
    end
  end
end