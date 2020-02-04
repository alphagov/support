class TransitionCheckerRequestsController < RequestsController
protected

  def new_request
    @transition_checker_request = Support::Requests::TransitionCheckerRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::TransitionCheckerTicket
  end

  def parse_request_from_params
    Support::Requests::TransitionCheckerRequest.new(transition_checker_params)
  end

  def transition_checker_params
    params.require(:support_requests_transition_checker_request)
          .permit(
            :action_to_change,
            :description_of_change,
            :change_link_to,
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
