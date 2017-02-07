require 'zendesk/ticket/taxonomy_change_topic_request_ticket'
require 'support/requests/taxonomy_change_topic_request'

class TaxonomyChangeTopicRequestsController < RequestsController
  include Support::Requests

protected

  def new_request
    TaxonomyChangeTopicRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::TaxonomyChangeTopicRequestTicket
  end

  def parse_request_from_params
    TaxonomyChangeTopicRequest.new(taxonomy_change_topic_request_params)
  end

  def taxonomy_change_topic_request_params
    params.require(:support_requests_taxonomy_change_topic_request).permit(
      :title, :type_of_change, :details, :reasons,
      requester_attributes: [:email, :name, :collaborator_emails],
    )
  end
end
