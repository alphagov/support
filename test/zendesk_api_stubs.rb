require 'zendesk_tickets'
require 'zendesk_error'

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

  [:subject, :tags, :description, :collaborators].each do |property|
    define_method(property) do
      @options[property]
    end
  end

  ZendeskTickets.field_ids.each do |field_name, field_id|
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

class ZenDeskAPIUsersDouble
  attr_reader :created_user_attributes

  def initialize
    @created_user_attributes = {}
    @should_raise_error = false
  end

  def should_raise_error
    @should_raise_error = true
  end

  def search(attributes)
    []
  end

  def create(new_user_attributes)
    if @should_raise_error
      raise ZendeskError, "error creating users"
    else
      @created_user_attributes = new_user_attributes
    end
  end
end

class ZenDeskAPIClientDouble
  attr_reader :ticket, :users

  def initialize
    @ticket = ZenDeskAPITicketDouble.new
    @users = ZenDeskAPIUsersDouble.new
  end
end
