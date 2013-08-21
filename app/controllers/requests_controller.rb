require "zendesk_tickets"
require 'support/requests/requester'
require 'support/permissions/ability'

class RequestsController < ApplicationController
  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { render "support/forbidden", status: 403 }
      format.json { render json: {"error" => "You have not been granted permission to create these requests."}, status: 403 }
    end
  end

  def new
    @request = new_request
    authorize! :new, @request
  end

  def create
    @request = parse_request_from_params
    authorize! :create, @request
    set_requester_on(@request)

    if @request.valid?
      process_valid_request(@request)
      respond_to do |format|
        format.html { redirect_to acknowledge_path }
        format.json { render nothing: true, status: 201 }
      end      
    else
      respond_to do |format|
        format.html { render :new, status: 400 }
        format.json { render json: {"errors" => @request.errors.to_a}, status: 400 }
      end
    end
  end

  protected
  def current_ability
    @current_ability ||= Support::Permissions::Ability.new(current_user)
  end

  def process_valid_request(submitted_request)
    ticket = zendesk_ticket_class.new(submitted_request)
    log_queue_sizes
    ZendeskTickets.new.raise_ticket(ticket)
  end

  private
  def log_queue_sizes
    Sidekiq::Stats.new.queues.each do |queue_name, queue_size|
      Statsd.new(::STATSD_HOST).gauge("govuk.app.support.queues.#{queue_name}", queue_size)
    end
  end

  def set_requester_on(request)
    request.requester ||= Support::Requests::Requester.new
    request.requester.name = current_user.name
    request.requester.email = current_user.email
  end
end
