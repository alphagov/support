require "zendesk_tickets"
require 'support/requests/requester'

class RequestsController < AuthorisationController
  def new
    @request = new_request
    authorize! :new, @request
  end

  def create
    @request = parse_request_from_params
    authorize! :create, @request
    set_requester_on(@request)

    if @request.valid?
      @request.save! if @request.respond_to?(:save!)
      save_to_zendesk(@request) if persistence_to_zendesk_necessary?
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
  def save_to_zendesk(submitted_request)
    ticket = zendesk_ticket_class.new(submitted_request)
    $statsd.time("#{::STATSD_PREFIX}.timings.querying_sidekiq_stats") { log_queue_sizes }
    $statsd.time("#{::STATSD_PREFIX}.timings.putting_ticket_on_queue") { ZendeskTickets.new.raise_ticket(ticket) }
  end

  private
  def log_queue_sizes
    Sidekiq::Stats.new.queues.each do |queue_name, queue_size|
      $statsd.gauge("govuk.app.support.queues.#{queue_name}", queue_size)
    end
  end

  def set_requester_on(request)
    request.requester ||= Support::Requests::Requester.new
    request.requester.name = current_user.name
    request.requester.email = current_user.email
  end

  def persistence_to_zendesk_necessary?
    true
  end
end
