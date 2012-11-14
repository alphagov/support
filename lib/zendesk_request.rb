require_relative "zendesk_ticket"

class ZendeskRequest

  def self.get_organisations(client)
    organisations_hash = {}
    client.ticket_fields.find(:id => '21494928').custom_field_options.each { |tf| organisations_hash[tf.name] = tf.value }
    organisations_hash
  end

  def self.raise_zendesk_request(client, params, from_route)
    raise_ticket(client, ZendeskTicket.new(params, from_route))
  end

  def self.raise_ticket(client, ticket_to_raise)
    client.ticket.create(
      :subject => ticket_to_raise.subject,
      :description => "Created via Govt API",
      :priority => "normal",
      :requester => {"locale_id" => 1, "name" => ticket_to_raise.name, "email" => ticket_to_raise.email},
      :fields => [{"id" => "21494928", "value" => ticket_to_raise.organisation},
                  {"id" => "21487987", "value" => ticket_to_raise.job},
                  {"id" => "21471291", "value" => ticket_to_raise.phone},
                  {"id" => "21485833", "value" => ticket_to_raise.need_by_date},
                  {"id" => "21502036", "value" => ticket_to_raise.not_before_date}],
      :tags => ticket_to_raise.tags,
      :comment => {:value => ticket_to_raise.comment})
  end
end
