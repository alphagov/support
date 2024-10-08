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
      allow(ZendeskTicketJob).to receive(:perform_async)
    end

    it "calls ZendeskTicketJob with correct arguments" do
      described_class.new.raise_ticket(ticket_to_raise)

      expect(ZendeskTicketJob).to have_received(:perform_async).with(
        "subject" => "Important matter",
        "priority" => "normal",
        "requester" => { "locale_id" => 1, "email" => "ab@c.com", "name" => "Harry Potter" },
        "collaborators" => [],
        "tags" => %w[govt_form campaign],
        "description" => "Biscuits for everyone",
      )
    end

    it "calls ZendeskTicketJob with custom_fields if they are defined in the child class" do
      ticket_with_custom_fields = instance_double(
        Zendesk::Ticket::ContentChangeRequestTicket,
        base_ticket_attr.merge(custom_fields:
        [{ "id" => 1_900_000_744_991, "value" => "2023-08-01" },
         { "id" => 1_900_000_744_992, "value" => "2023-08-10" }]),
      )

      described_class.new.raise_ticket(ticket_with_custom_fields)

      expect(ZendeskTicketJob).to have_received(:perform_async).with(
        hash_including(
          "custom_fields" => [
            { "id" => 1_900_000_744_991, "value" => "2023-08-01" },
            { "id" => 1_900_000_744_992, "value" => "2023-08-10" },
          ],
        ),
      )
    end

    it "calls ZendeskTicketJob with ticket_form_id if the constant is defined in the child class" do
      ticket_with_form_id = instance_double(
        Zendesk::Ticket::ContentChangeRequestTicket,
        base_ticket_attr,
      )
      allow(ticket_with_form_id).to receive(:class).and_return(Zendesk::Ticket::ContentChangeRequestTicket)
      stub_const("Zendesk::Ticket::ContentChangeRequestTicket::TICKET_FORM_ID", 123)

      described_class.new.raise_ticket(ticket_with_form_id)

      expect(ZendeskTicketJob).to have_received(:perform_async).with(
        hash_including(
          "ticket_form_id" => 123,
        ),
      )
    end
  end
end
