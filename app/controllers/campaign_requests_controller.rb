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
      requester_attributes: %i[email name collaborator_emails],
      campaign_attributes: %i[
        signed_campaign
        has_read_guidance_confirmation
        has_read_oasis_guidance_confirmation
        full_responsibility_confirmation
        accessibility_confirmation
        cookie_and_privacy_notice_confirmation
        start_date
        end_date
        development_start_date
        performance_review_contact_email
        government_theme
        description
        call_to_action
        proposed_url
        site_title
        site_tagline
        site_metadescription
        cost_of_campaign
        ga_contact_email
      ],
    ).to_h
  end
end
