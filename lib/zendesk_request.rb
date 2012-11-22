require_relative "zendesk_ticket"
require 'ostruct'

class ZendeskRequest
  def self.field_ids
    { organisation:    "21494928",
      job:             "21487987",
      phone:           "21471291",
      needed_by_date:  "21485833",
      not_before_date: "21502036" }
  end

  def self.get_organisations(client)
    organisations_hash = {}
    client.ticket_fields.find(:id => '21494928').custom_field_options.each { |tf| organisations_hash[tf.name] = tf.value }
    organisations_hash
  end

  def self.raise_zendesk_request(client, params, from_route)
    raise_ticket(client, ZendeskTicket.new(OpenStruct.new(params), from_route))
  end

  def self.raise_ticket(client, ticket_to_raise)
    client.ticket.create(
      :subject => ticket_to_raise.subject,
      :description => "Created via Govt API",
      :priority => "normal",
      :requester => {"locale_id" => 1, "name" => ticket_to_raise.name, "email" => ticket_to_raise.email},
      :fields => [{"id" => ZendeskRequest.field_ids[:organisation],    "value" => ticket_to_raise.organisation},
                  {"id" => ZendeskRequest.field_ids[:job],             "value" => ticket_to_raise.job},
                  {"id" => ZendeskRequest.field_ids[:phone],           "value" => ticket_to_raise.phone},
                  {"id" => ZendeskRequest.field_ids[:needed_by_date],  "value" => ticket_to_raise.needed_by_date},
                  {"id" => ZendeskRequest.field_ids[:not_before_date], "value" => ticket_to_raise.not_before_date}],
      :tags => ticket_to_raise.tags,
      :comment => {:value => ticket_to_raise.comment})
  end
end
