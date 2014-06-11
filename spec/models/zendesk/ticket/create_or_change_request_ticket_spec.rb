require 'spec_helper'
require 'zendesk/ticket/create_or_change_user_request_ticket'

module Zendesk
  module Ticket
    describe CreateOrChangeUserRequestTicket do
      it "is tagged with inside_government if it relates to depts and policy" do
        ticket = CreateOrChangeUserRequestTicket.new(
          double(requester: nil, inside_government_related?: true, action: "create_new_user")
        )

        expect(ticket.tags).to include("create_new_user", "inside_government")
      end
    end
  end
end
