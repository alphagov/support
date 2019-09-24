require "rails_helper"

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

      it 'includes a "content_amend" tag' do
        expect(ticket.tags).to include("content_amend")
      end
    end
  end
end
