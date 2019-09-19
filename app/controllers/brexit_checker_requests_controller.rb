class BrexitCheckerRequestsController < RequestsController
protected

  def new_request
    @get_ready_for_brexit_checker_request = Support::Requests::BrexitCheckerRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::BrexitCheckerTicket
  end

  def parse_request_from_params
    Support::Requests::BrexitCheckerRequest.new(brexit_checker_params)
  end

  def brexit_checker_params
    params.require(:support_requests_brexit_checker_request)
          .permit(
            :action_to_change,
            :description_of_change,
            :new_action_users,
            :new_action_title,
            :new_action_consequence,
            :new_action_service_link,
            :new_action_guidance_link,
            :new_action_lead_time,
            :new_action_deadline,
            :new_action_comments,
            :new_action_priority,
            requester_attributes: %i[email name collaborator_emails],
          )
          .to_h
  end
end
