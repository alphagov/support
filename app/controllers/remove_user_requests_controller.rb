require 'zendesk/ticket/remove_user_request_ticket'
require 'support/requests/remove_user_request'

class RemoveUserRequestsController < RequestsController
  include Support::Requests

  protected
  def new_request
    RemoveUserRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::RemoveUserRequestTicket
  end

  def parse_request_from_params
    RemoveUserRequest.new(remove_user_request_params)
  end

  def remove_user_request_params
    params.require(:support_requests_remove_user_request).permit(
      :user_name, :user_email, :reason_for_removal,
      requester_attributes: [:email, :name, :collaborator_emails],
      time_constraint_attributes: [:not_before_date, :needed_by_date, :time_constraint_reason],
    ).to_h
  end
end
