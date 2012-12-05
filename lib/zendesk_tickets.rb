require_relative "zendesk_ticket"

class ZendeskTickets
  def initialize(client)
    @client = client
  end

  def self.field_ids
    { needed_by_date:  "21485833",
      not_before_date: "21502036" }
  end

  def raise_ticket(ticket_to_raise)
    @client.ticket.create(
      :subject => ticket_to_raise.subject,
      :description => "Created via Govt API",
      :priority => "normal",
      :requester => {"locale_id" => 1, "email" => ticket_to_raise.email},
      :collaborators => ticket_to_raise.collaborator_emails,
      :fields => [{"id" => ZendeskTickets.field_ids[:needed_by_date],  "value" => ticket_to_raise.needed_by_date},
                  {"id" => ZendeskTickets.field_ids[:not_before_date], "value" => ticket_to_raise.not_before_date}],
      :tags => ticket_to_raise.tags,
      :comment => {:value => ticket_to_raise.comment})
  end
end
