class RemoveUserRequestsController < RequestsController
  def new
    @use_design_system = true
    super
  end

protected

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
      :user_name,
      :user_email,
      :reason_for_removal,
      requester_attributes: %i[email name collaborator_emails],
      time_constraint_attributes: %i[needed_by_day needed_by_month needed_by_year time_constraint_reason not_before_day not_before_month not_before_year],
    ).to_h
  end
end
