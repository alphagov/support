require "rails_helper"

describe Zendesk::ZendeskTickets do
  let(:base_ticket_attr) do
    { subject: "Important matter",
      priority: "normal",
      email: "ab@c.com",
      name: "Harry Potter",
      collaborator_emails: [],
      tags: %w[govt_form campaign],
      comment: "Biscuits for everyone" }
  end
  let(:ticket_to_raise) { double("SomeRequestTicket", base_ticket_attr) }

  describe "#raise_ticket" do
    before do
      allow(ZendeskTicketWorker).to receive(:perform_async)
    end

    it "calls ZendeskTicketWorker with correct arguments" do
      described_class.new.raise_ticket(ticket_to_raise)

      expect(ZendeskTicketWorker).to have_received(:perform_async).with(
        "subject" => "Important matter",
        "priority" => "normal",
        "requester" => { "locale_id" => 1, "email" => "ab@c.com", "name" => "Harry Potter" },
        "collaborators" => [],
        "tags" => %w[govt_form campaign],
        "comment" => { "body" => "Biscuits for everyone" },
      )
    end
  end
end
