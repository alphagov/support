require 'bundler'
Bundler.require

require "yaml"
require_relative "zendesk_ticket"

class ZendeskClient

  def self.get_username_password(config_details)
    environment = ENV['GOVUK_ENV'] || "development"
    [config_details[environment]["username"].to_s, config_details[environment]["password"].to_s]
  end

  @client = ZendeskAPI::Client.new { |config|
    file = YAML::load_file(File.open('./config/zendesk.yml'))
    login_details = self.get_username_password(file)
    config.url = "https://govuk.zendesk.com/api/v2/"
    config.username = login_details[0]
    config.password = login_details[1]
  }

  def self.get_departments
    departments_hash = {"Select Department" => ""}
    @client.ticket_fields.find(:id => '21494928').custom_field_options.each { |tf| departments_hash[tf.name] = tf.value }
    departments_hash
  end

  def self.raise_zendesk_request(params, from_route)
    ticket_to_raise = ZendeskTicket.new(params, from_route)

    if ticket_to_raise.has_attachments
      create_ticket_with_attachment(ticket_to_raise)
    else
      @client.ticket.create(
          :subject => ticket_to_raise.subject,
          :description => "Created via Govt API",
          :priority => "normal",
          :requester => {"locale_id" => 1, "name" => ticket_to_raise.name, "email" => ticket_to_raise.email},
          :fields => [{"id" => "21494928", "value" => ticket_to_raise.department},
                      {"id" => "21487987", "value" => ticket_to_raise.job},
                      {"id" => "21471291", "value" => ticket_to_raise.phone},
                      {"id" => "21485833", "value" => ticket_to_raise.need_by_date},
                      {"id" => "21502036", "value" => ticket_to_raise.not_before_date}],
          :tags => [ticket_to_raise.tag],
          :comment => {:value => ticket_to_raise.comment})
    end
  end

  def self.upload_file(path)
    upload = ZendeskAPI::Upload.create(@client, :file => File.open(path))
    upload.token
  end

  def self.create_ticket_with_attachment(ticket_to_raise)
    @client.ticket.create(
        :subject => ticket_to_raise.subject,
        :description => "Created via Govt API",
        :priority => "normal",
        :requester => {"locale_id" => 1, "name" => ticket_to_raise.name, "email" => ticket_to_raise.email},
        :fields => [{"id" => "21494928", "value" => ticket_to_raise.department},
                    {"id" => "21487987", "value" => ticket_to_raise.job},
                    {"id" => "21471291", "value" => ticket_to_raise.phone},
                    {"id" => "21485833", "value" => ticket_to_raise.need_by_date},
                    {"id" => "21502036", "value" => ticket_to_raise.not_before_date}],
        :tags => [ticket_to_raise.tag],
        :comment => {:value => ticket_to_raise.comment, :uploads => ticket_to_raise.file_token})
  end

  def self.remove_space_from_phone_number(number)
    number.gsub(/\s+/, "")
  end
end
