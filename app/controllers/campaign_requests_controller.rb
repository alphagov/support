require 'zendesk/ticket/campaign_request_ticket'
require 'support/requests/campaign_request'

class CampaignRequestsController <  RequestsController
  include Support::Requests

  protected
  def new_request
    CampaignRequest.new(campaign: Support::GDS::Campaign.new)
  end

  def zendesk_ticket_class
    Zendesk::Ticket::CampaignRequestTicket
  end

  def parse_request_from_params
    CampaignRequest.new(params[:support_requests_campaign_request])
  end
end