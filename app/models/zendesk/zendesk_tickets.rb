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
      ticket_options.merge!(custom_fields: ticket_to_raise.custom_fields) if ticket_to_raise.respond_to?(:custom_fields)
      ticket_options.merge!(ticket_form_id: ticket_to_raise.class::TICKET_FORM_ID) if ticket_to_raise.class.const_defined?(:TICKET_FORM_ID)

      ZendeskTicketWorker.perform_async(ticket_options.stringify_keys)
    end
  end
end
