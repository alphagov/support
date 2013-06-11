require "zendesk_tickets"
require 'support/requests/requester'
require 'support/permissions/ability'
require 'gds_zendesk/zendesk_error'

class RequestsController < ApplicationController
  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    render "support/forbidden", status: 403
  end

  def new
    @request = new_request
    authorize! :new, @request
  end

  def create
    @request = parse_request_from_params
    authorize! :create, @request
    set_logged_in_user_as_requester_on(@request)

    if @request.valid?
      process_valid_request(@request)
    else
      render :new, status: 400
    end
  end

  protected
  def current_ability
    @current_ability ||= Support::Permissions::Ability.new(current_user)
  end

  def process_valid_request(submitted_request)
    raise_ticket(zendesk_ticket_class.new(submitted_request))
  end

  private
  def set_logged_in_user_as_requester_on(request)
    request.requester ||= Support::Requests::Requester.new
    request.requester.name = current_user.name
    request.requester.email = current_user.email
  end

  def raise_ticket(ticket)
    ticket = ZendeskTickets.new(GDS_ZENDESK_CLIENT).raise_ticket(ticket)

    if ticket
      redirect_to acknowledge_path
    else
      return render "support/zendesk_error", locals: { error_string: "Zendesk timed out", ticket: ticket }
    end
  rescue GDSZendesk::ZendeskError => e
    request.env["sso-credentials"] = "#{current_user.name} <#{current_user.email}>"
    ExceptionNotifier::Notifier.exception_notification(request.env, e).deliver
    render "support/zendesk_error", status: 500, locals: { error_string: e.underlying_message, 
                                                           ticket: ticket }
  end
end
