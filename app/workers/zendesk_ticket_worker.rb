class ZendeskTicketWorker
  include Sidekiq::Worker

  def perform(ticket_options)
    if GDS_ZENDESK_CLIENT.users.suspended?(ticket_options["requester"]["email"])
      GovukStatsd.increment("report_a_problem.submission_from_suspended_user")
    else
      begin
        if ticket_options["requester"]["name"] && ticket_options["requester"]["name"].length > 255
          GovukStatsd.increment("report_a_problem.zendesk_ticket_name_too_long")
        else
          create_ticket(ticket_options)
        end
      rescue ZendeskAPI::Error::NetworkError => e
        if e.response.status == 409
          GovukStatsd.increment("exception.409_conflict_response") #if Zendesk has already received the ticket, we should stop trying. All we do is record the error in Grafana.
        else
          raise
        end
      end
    end
  end

private

  def create_ticket(ticket_options)
    GDS_ZENDESK_CLIENT.ticket.create!(HashWithIndifferentAccess.new(ticket_options))
  end
end
