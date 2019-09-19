module Zendesk
  module Ticket
    class BrexitCheckerTicket < Zendesk::ZendeskTicket
      def subject
        "Get ready for Brexit checker"
      end
    end
  end
end
