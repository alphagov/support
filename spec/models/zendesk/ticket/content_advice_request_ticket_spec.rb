require 'spec_helper'

module Zendesk
  module Ticket
    describe ContentAdviceRequestTicket do
      def ticket(opts = {})
        defaults = { requester: nil, title: nil, time_constraint: double(needed_by_date: nil) }
        ContentAdviceRequestTicket.new(double(defaults.merge(opts)))
      end

      it "contains the request title in the subject, if one is provided" do
        expect(ticket(title: "Abc").subject).to eq("Abc - Advice on content")
      end

      it "has a default subject" do
        expect(ticket.subject).to eq("Advice on content")
      end

      it "contains the deadline in the subject, if one is provided" do
        t = ticket(title: "Abc", time_constraint: double(needed_by_date: "12-04-2020"))
        expect(t.subject).to eq("Needed by 12 Apr: Abc - Advice on content")
      end
    end
  end
end
