require 'zendesk_api/error'

class ZendeskTicketWorker
  include Sidekiq::Worker
  
  def perform(ticket_options)
    GDS_ZENDESK_CLIENT.ticket.create!(HashWithIndifferentAccess.new(ticket_options))
  rescue ZendeskAPI::Error::ClientError => e
    data = { data: { ticket: ticket_options } } 
    data[:data][:zendesk_errors] = e.errors if e.respond_to?(:errors)
    ExceptionNotifier::Notifier.background_exception_notification(e, data).deliver
  end
end
