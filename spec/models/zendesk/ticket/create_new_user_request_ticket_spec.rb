require "rails_helper"

module Zendesk
  module Ticket
    describe CreateNewUserRequestTicket do
      it "is tagged with inside_government if it relates to depts and policy" do
        ticket = CreateNewUserRequestTicket.new(
          double(requester: nil, inside_government_related?: true, action: "create_new_user"),
        )

        expect(ticket.tags).to include("create_new_user", "inside_government")
      end
    end
  end
end
