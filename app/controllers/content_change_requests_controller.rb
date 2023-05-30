class ContentChangeRequestsController < RequestsController
protected

  def new_request
    Support::Requests::ContentChangeRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::ContentChangeRequestTicket
  end

  def parse_request_from_params
    Support::Requests::ContentChangeRequest.new(content_change_request_params)
  end

  def content_change_request_params
    params.require(:support_requests_content_change_request).permit(
      :title,
      :reason_for_change,
      :subject_area,
      :details_of_change,
      :why_is_change_needed,
      :url,
      :related_urls,
      requester_attributes: %i[email name collaborator_emails],
      time_constraint_attributes: %i[not_before_date needed_by_date time_constraint_reason needed_by_time not_before_time],
    ).to_h
  end
end
