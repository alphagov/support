class FoiRequestsController < RequestsController
protected # rubocop:disable Layout/IndentationWidth https://github.com/rubocop-hq/rubocop/issues/6861

  def new_request
    Support::Requests::FoiRequest.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::FoiRequestTicket
  end

  def parse_request_from_params
    Support::Requests::FoiRequest.new(foi_request_params)
  end

  def set_requester_on(request)
    request.requester = Support::Requests::Requester.new(foi_request_params[:requester])
  end

  def foi_request_params
    params.require(:foi_request).permit(
      :details, requester: %i[email name]
    ).to_h
  end
end
