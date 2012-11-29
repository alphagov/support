require 'zendesk_request'

module ZendeskApiStubsHelper
  def stub_zendesk_ticket_submission
    @zendesk_api = ZenDeskAPIClientDouble.new
    ZendeskClient.stubs(:get_client).returns(@zendesk_api)
  end
end

class ZenDeskAPITicketDouble
  attr_reader :options

  def create(options)
    @options = options
  end

  [:subject, :tags, :description].each do |property|
    define_method(property) do
      @options[property]
    end
  end

  ZendeskRequest.field_ids.each do |field_name, field_id|
    define_method(field_name) do
      value_of_field_with_id(field_id)
    end
  end

  def name
    @options[:requester]["name"]
  end

  def email
    @options[:requester]["email"]
  end

  def comment
    @options[:comment][:value]
  end

  protected
  def value_of_field_with_id(field_id)
    correct_field = @options[:fields].detect {|field| field["id"] == field_id}
    correct_field["value"]
  end
end

class ZenDeskAPIClientDouble
  attr_reader :ticket

  def initialize
    @ticket = ZenDeskAPITicketDouble.new
  end
end
