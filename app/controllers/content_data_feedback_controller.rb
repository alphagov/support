class ContentDataFeedbackController < RequestsController
protected

  def new_request
    Support::Requests::ContentDataFeedback.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::ContentDataFeedbackTicket
  end

  def parse_request_from_params
    Support::Requests::ContentDataFeedback.new(content_data_feedback_params)
  end

  def content_data_feedback_params
    params.require(
      :support_requests_content_data_feedback,
    ).permit(
      :feedback_type,
      :feedback_details,
      :impact_on_work,
      requester_attributes: %i[email name collaborator_emails],
    ).to_h
  end
end
