require 'campaign_request_zendesk_ticket'

class CampaignRequestsController <  RequestsController
  protected
  def request_class
    CampaignRequest
  end

  def new_request
    request_class.new(:requester => Requester.new, :campaign => Campaign.new)
  end

  def zendesk_ticket_class
    CampaignRequestZendeskTicket
  end

  def parse_request_from_params
    request_class.new(params[:campaign_request])
  end
end