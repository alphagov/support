module Zendesk
  class ZendeskTickets
    def raise_ticket(ticket_to_raise)
      ticket_options = {
        subject: ticket_to_raise.subject,
        priority: ticket_to_raise.priority,
        requester: { "locale_id" => 1, "email" => ticket_to_raise.email, "name" => ticket_to_raise.name },
        collaborators: ticket_to_raise.collaborator_emails,
        tags: ticket_to_raise.tags,
        comment: { "body" => ticket_to_raise.comment },
      }

      ZendeskTicketWorker.perform_async(ticket_options.stringify_keys)
    end
  end
end
