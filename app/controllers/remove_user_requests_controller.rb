class RemoveUserRequestsController < RequestsController
protected # rubocop:disable Layout/IndentationWidth https://github.com/rubocop-hq/rubocop/issues/6861

  def new_request
    Support::Requests::RemoveUserRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::RemoveUserRequestTicket
  end

  def parse_request_from_params
    Support::Requests::RemoveUserRequest.new(remove_user_request_params)
  end

  def remove_user_request_params
    params.require(:support_requests_remove_user_request).permit(
      :user_name, :user_email, :reason_for_removal,
      requester_attributes: %i[email name collaborator_emails],
      time_constraint_attributes: %i[not_before_date needed_by_date time_constraint_reason],
    ).to_h
  end
end
