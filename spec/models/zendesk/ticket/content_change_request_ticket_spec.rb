require 'spec_helper'
require 'zendesk/ticket/content_change_request_ticket'

module Zendesk
  module Ticket
    describe ContentChangeRequestTicket do
      def ticket(opts = {})
        defaults = { requester: nil, title: nil }
        ContentChangeRequestTicket.new(double(defaults.merge(opts)))
      end

      it "contains the title in the subject, if one is provided" do
        expect(ticket(title: "Abc").subject).to eq("Abc - Content change request")
      end

      it "has a default subject" do
        expect(ticket.subject).to eq("Content change request")
      end

      context "an inside government request" do
        subject { ticket(inside_government_related?: true) }
        its(:tags) { should include("content_amend", "inside_government") }
      end
    end
  end
end
