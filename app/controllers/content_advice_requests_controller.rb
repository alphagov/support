class ContentAdviceRequestsController < RequestsController
protected

  def new_request
    Support::Requests::ContentAdviceRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::ContentAdviceRequestTicket
  end

  def parse_request_from_params
    Support::Requests::ContentAdviceRequest.new(content_advice_request_params)
  end

  def content_advice_request_params
    params.require(:support_requests_content_advice_request).permit(
      :title,
      :details,
      :urls,
      :contact_number,
      requester_attributes: %i[email name collaborator_emails],
      time_constraint_attributes: %i[needed_by_date time_constraint_reason],
    ).to_h
  end
end
