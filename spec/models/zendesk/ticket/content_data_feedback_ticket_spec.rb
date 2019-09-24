require "rails_helper"

module Zendesk
  module Ticket
    describe ContentDataFeedbackTicket do
      let(:ticket) do
        ContentDataFeedbackTicket.new(double(requester: nil))
      end

      it "has a default subject" do
        expect(ticket.subject).to eq("Content Data feedback")
      end

      it 'includes a "content_data_feedback" tag' do
        expect(ticket.tags).to include("content_data_feedback")
      end
    end
  end
end
