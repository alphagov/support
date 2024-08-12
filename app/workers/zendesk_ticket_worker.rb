class ZendeskTicketWorker
  include Sidekiq::Worker

  sidekiq_retry_in do |exception|
    case exception
    when ZendeskTicketError::TicketNameTooLong
      :kill
    when GdsApi::HTTPConflict
      # Discard the job if the support ticket has been created
      :discard
    end
  end

  def perform(ticket_options)
    if ticket_options["requester"]["name"] && ticket_options["requester"]["name"].length > 255
      raise TicketNameTooLong, "Zendesk requester name (#{ticket_options['requester']['name']}) was too long (over 255 characters)"
    else
      create_ticket(ticket_options)
    end
  end

private

  def create_ticket(ticket_options)
    Services.support_api.raise_support_ticket(HashWithIndifferentAccess.new(ticket_options))
  end

  class TicketNameTooLong < StandardError; end
end
