class GeneralRequestsController < RequestsController
  protected
  def new_request
    Support::Requests::GeneralRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::GeneralRequestTicket
  end

  def parse_request_from_params
    user_request = Support::Requests::GeneralRequest.new(general_request_params)
    user_request.user_agent = request.user_agent
    user_request
  end

  def general_request_params
    params.require(:support_requests_general_request).permit(
      :title, :url, :details,
      requester_attributes: [:email, :name, :collaborator_emails],
    ).to_h
  end
end
