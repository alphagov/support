class NamedContactsController < RequestsController
  protected
  def new_request
    Support::Requests::NamedContact.new
  end

  def zendesk_ticket_class
    Zendesk::Ticket::NamedContactTicket
  end

  def parse_request_from_params
    Support::Requests::NamedContact.new(named_contact_params)
  end

  def set_requester_on(request)
    request.requester = Support::Requests::Requester.new(named_contact_params[:requester])
  end

  def named_contact_params
    params.require(:named_contact).permit(
      :details, :link, :referrer, :javascript_enabled, :user_agent,
      requester: [:email, :name],
    ).to_h
  end
end
