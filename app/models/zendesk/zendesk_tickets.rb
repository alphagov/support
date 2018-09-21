module Zendesk
  class ZendeskTickets
    def raise_ticket(ticket_to_raise)
      ticket_data = {
        subject: ticket_to_raise.subject,
        priority: ticket_to_raise.priority,
        requester: { "locale_id" => 1, "email" => ticket_to_raise.email, "name" => ticket_to_raise.name },
        collaborators: ticket_to_raise.collaborator_emails,
        tags: ticket_to_raise.tags,
        comment: { "body" => ticket_to_raise.comment }
      }
      # temporary while Content Publisher is in private beta
      ticket_data[:assignee_id] = ticket_to_raise.assignee_id if ticket_to_raise.assignee_id.present?
      ZendeskTicketWorker.perform_async(ticket_data)
    end
  end
end
