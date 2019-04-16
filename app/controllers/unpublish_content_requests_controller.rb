class UnpublishContentRequestsController < RequestsController
protected # rubocop:disable Layout/IndentationWidth https://github.com/rubocop-hq/rubocop/issues/6861

  def new_request
    Support::Requests::UnpublishContentRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::UnpublishContentRequestTicket
  end

  def parse_request_from_params
    Support::Requests::UnpublishContentRequest.new(unpublish_content_request_params)
  end

  def unpublish_content_request_params
    params.require(:support_requests_unpublish_content_request).permit(
      :urls, :reason_for_unpublishing, :further_explanation, :redirect_url,
      :automatic_redirect,
      requester_attributes: %i[email name collaborator_emails],
    ).to_h
  end
end
