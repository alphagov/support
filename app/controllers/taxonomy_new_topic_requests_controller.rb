require 'zendesk/ticket/taxonomy_new_topic_request_ticket'
require 'support/requests/taxonomy_new_topic_request'

class TaxonomyNewTopicRequestsController < RequestsController
  include Support::Requests

protected

  def new_request
    TaxonomyNewTopicRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::TaxonomyNewTopicRequestTicket
  end

  def parse_request_from_params
    TaxonomyNewTopicRequest.new(taxonomy_new_topic_request_params)
  end

  def taxonomy_new_topic_request_params
    params.require(:support_requests_taxonomy_new_topic_request).permit(
      :title, :url, :details, :parent,
      requester_attributes: [:email, :name, :collaborator_emails],
    ).to_h
  end
end
