require 'zendesk/ticket/analytics_request_ticket'
require 'support/requests/analytics_request'

class AnalyticsRequestsController < RequestsController
  include Support::Requests

  protected
  def new_request
    AnalyticsRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::AnalyticsRequestTicket
  end

  def parse_request_from_params
    AnalyticsRequest.new(analytics_request_params)
  end

  def analytics_request_params
    params.require(:support_requests_analytics_request).permit(
      :google_analytics_request_details,
      :single_point_of_contact_request_details,
      :report_request_details,
      :help_request_details,
      requester_attributes: [
        :email,
        :name,
        :collaborator_emails
      ],
    ).to_h
  end
end
