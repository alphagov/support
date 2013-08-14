require 'zendesk_api/error'

class ZendeskTicketWorker
  include Sidekiq::Worker
  
  def perform(ticket_options)
    if GDS_ZENDESK_CLIENT.users.suspended?(ticket_options["requester"]["email"])
      Statsd.new(::STATSD_HOST).increment("#{::STATSD_PREFIX}.report_a_problem.submission_from_suspended_user")
    else
      GDS_ZENDESK_CLIENT.ticket.create(HashWithIndifferentAccess.new(ticket_options))
    end
  rescue ZendeskAPI::Error::ClientError => e
    data = { data: { ticket: ticket_options } } 
    data[:data][:zendesk_errors] = e.errors if e.respond_to?(:errors)
    ExceptionNotifier::Notifier.background_exception_notification(e, data).deliver
  end
end
