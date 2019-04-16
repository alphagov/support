class ContentPublisherFeedbackRequestsController < RequestsController
protected # rubocop:disable Layout/IndentationWidth https://github.com/rubocop-hq/rubocop/issues/6861

  def new_request
    Support::Requests::ContentPublisherFeedbackRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::ContentPublisherFeedbackRequestTicket
  end

  def parse_request_from_params
    Support::Requests::ContentPublisherFeedbackRequest.new(content_publisher_feedback_request_params)
  end

  def content_publisher_feedback_request_params
    params.require(:support_requests_content_publisher_feedback_request).permit(
      :feedback_type,
      :feedback_details,
      :impact_on_work,
      requester_attributes: %i[email name collaborator_emails],
    ).to_h
  end
end
