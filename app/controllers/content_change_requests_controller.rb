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
      :url,
      :related_urls,
      requester_attributes: %i[email name collaborator_emails],
      time_constraint_attributes: %i[not_before_day not_before_month not_before_year needed_by_date needed_by_day needed_by_month needed_by_year time_constraint_reason needed_by_time not_before_time],
    ).to_h
  end
end
