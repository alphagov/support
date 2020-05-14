class TaxonomyNewTopicRequestsController < RequestsController
protected

  def new_request
    Support::Requests::TaxonomyNewTopicRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::TaxonomyNewTopicRequestTicket
  end

  def parse_request_from_params
    Support::Requests::TaxonomyNewTopicRequest.new(taxonomy_new_topic_request_params)
  end

  def taxonomy_new_topic_request_params
    params.require(:support_requests_taxonomy_new_topic_request).permit(
      :title,
      :url,
      :details,
      :parent,
      requester_attributes: %i[email name collaborator_emails],
    ).to_h
  end
end
