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
    CampaignRequest.new(campaign_request_params)
  end

  def campaign_request_params
    params.require(:support_requests_campaign_request).permit(
      :additional_comments,
      requester_attributes: [:email, :name, :collaborator_emails],
      campaign_attributes: [
        :title, :erg_reference_number, :start_date, :description, :affiliated_group_or_company, :info_url
      ]
    )
  end
end
