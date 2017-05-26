class CampaignRequestsController < RequestsController
  protected
  def new_request
    Support::Requests::CampaignRequest.new(campaign: Support::GDS::Campaign.new)
  end

  def zendesk_ticket_class
    Zendesk::Ticket::CampaignRequestTicket
  end

  def parse_request_from_params
    Support::Requests::CampaignRequest.new(campaign_request_params)
  end

  def campaign_request_params
    params.require(:support_requests_campaign_request).permit(
      :additional_comments,
      requester_attributes: [:email, :name, :collaborator_emails],
      campaign_attributes: [
          :title, :other_dept_or_agency, :signed_campaign, :start_date, :end_date, :description,
          :call_to_action, :success_measure, :proposed_url, :site_metadescription, :cost_of_campaign
      ]
    ).to_h
  end
end
