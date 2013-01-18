require 'gds_zendesk/field_mappings'

class ZendeskTickets
  def initialize(client)
    @client = client
  end

  def raise_ticket(ticket_to_raise)
    @client.ticket.create(
      :subject => ticket_to_raise.subject,
      :description => "Created via Govt API",
      :priority => "normal",
      :requester => {"locale_id" => 1, "email" => ticket_to_raise.email, "name" => ticket_to_raise.name},
      :collaborators => ticket_to_raise.collaborator_emails,
      :fields => [{"id" => GDSZendesk::FIELD_MAPPINGS[:needed_by_date],  "value" => ticket_to_raise.needed_by_date},
                  {"id" => GDSZendesk::FIELD_MAPPINGS[:not_before_date], "value" => ticket_to_raise.not_before_date}],
      :tags => ticket_to_raise.tags,
      :comment => {:value => ticket_to_raise.comment})
  end
end
