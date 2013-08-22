require 'zendesk_api/error'

class ZendeskTicketWorker
  include Sidekiq::Worker
  
  def perform(ticket_options)
    if GDS_ZENDESK_CLIENT.users.suspended?(ticket_options["requester"]["email"])
      Statsd.new(::STATSD_HOST).increment("#{::STATSD_PREFIX}.report_a_problem.submission_from_suspended_user")
    else
      GDS_ZENDESK_CLIENT.ticket.create!(HashWithIndifferentAccess.new(ticket_options))
    end
  end
end
