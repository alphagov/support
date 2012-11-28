require 'campaign_request_zendesk_ticket'

class CampaignRequestsController <  RequestsController
  protected
  def new_request
    CampaignRequest.new(:requester => Requester.new, :campaign => Campaign.new)
  end

  def zendesk_ticket_class
    CampaignRequestZendeskTicket
  end

  def parse_request_from_params
    CampaignRequest.new(params[:campaign_request])
  end
end