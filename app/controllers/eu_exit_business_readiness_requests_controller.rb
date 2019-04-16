class EuExitBusinessReadinessRequestsController < RequestsController
protected # rubocop:disable Layout/IndentationWidth https://github.com/rubocop-hq/rubocop/issues/6861

  def new_request
    Support::Requests::EuExitBusinessReadinessRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::EuExitBusinessReadinessTicket
  end

  def parse_request_from_params
    Support::Requests::EuExitBusinessReadinessRequest.new(eu_exit_business_readiness_params)
  end

  def eu_exit_business_readiness_params
    params.require(
      :support_requests_eu_exit_business_readiness_request
    ).permit(
      :type,
      :url,
      :pinned_content,
      :explanation,
      :employing_eu_citizens,
      :personal_data,
      requester_attributes: %i[email name collaborator_emails],
      sector: [],
      business_activity: [],
      intellectual_property: [],
      funding_schemes: [],
      public_sector_procurement: [],
    ).to_h
  end
end
