class EuExitBusinessReadinessRequestsController < RequestsController
protected

  def new_request
    @eu_exit_business_readiness_request = Support::Requests::EuExitBusinessReadinessRequest.new
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
      :explanation,
      :employing_eu_citizens,
      :personal_data,
      requester_attributes: %i[email name collaborator_emails],
      sector: [],
      organisation_activity: [],
      intellectual_property: [],
      funding_schemes: [],
      public_sector_procurement: [],
    ).to_h
  end
end
