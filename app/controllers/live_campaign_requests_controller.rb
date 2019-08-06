class LiveCampaignRequestsController < RequestsController
protected

  def new_request
    Support::Requests::LiveCampaignRequest.new(live_campaign: Support::GDS::LiveCampaign.new)
  end

  def zendesk_ticket_class
    Zendesk::Ticket::LiveCampaignRequestTicket
  end

  def parse_request_from_params
    Support::Requests::LiveCampaignRequest.new(live_campaign_request_params)
  end

  def live_campaign_request_params
    params.require(:support_requests_live_campaign_request).permit(
      :additional_comments,
      requester_attributes: %i[email name collaborator_emails],
      live_campaign_attributes: %i[
        title proposed_url description time_constraints reason_for_dates
      ]
    ).to_h
  end
end
