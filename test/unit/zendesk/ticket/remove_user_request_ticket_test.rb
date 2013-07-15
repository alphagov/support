require 'test/unit'
require 'shoulda/context'
require 'zendesk/ticket/remove_user_request_ticket'
require 'ostruct'

module Zendesk
  module Ticket
    class RemoveUserRequestTicketTest < Test::Unit::TestCase
      def ticket(opts = {})
        RemoveUserRequestTicket.new(stub_everything("request", opts))
      end

      should "be tagged with remove_user" do
        tags_on_ticket = ticket.tags
        assert_includes tags_on_ticket, "remove_user"
      end
    end
  end
end