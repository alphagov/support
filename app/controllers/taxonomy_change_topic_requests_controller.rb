class TaxonomyChangeTopicRequestsController < RequestsController
protected

  def new_request
    Support::Requests::TaxonomyChangeTopicRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::TaxonomyChangeTopicRequestTicket
  end

  def parse_request_from_params
    Support::Requests::TaxonomyChangeTopicRequest.new(taxonomy_change_topic_request_params)
  end

  def taxonomy_change_topic_request_params
    params.require(:support_requests_taxonomy_change_topic_request).permit(
      :title, :type_of_change, :details, :reasons,
      requester_attributes: %i[email name collaborator_emails],
    ).to_h
  end
end
