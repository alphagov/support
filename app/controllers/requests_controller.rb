require "sidekiq/api"

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
      save_to_zendesk(@request)
      respond_to do |format|
        format.html { redirect_to acknowledge_path }
        format.json { head :created }
      end
    else
      respond_to do |format|
        format.html do
          flash.now[:alert] = @request.errors.full_messages.join('\n')
          render :new, status: 400
        end
        format.json { render json: { "errors" => @request.errors.to_a }, status: 400 }
      end
    end
  end

protected

  def save_to_zendesk(submitted_request)
    ticket = zendesk_ticket_class.new(submitted_request)
    GovukStatsd.client.time("timings.querying_sidekiq_stats") { log_queue_sizes }
    GovukStatsd.client.time("timings.putting_ticket_on_queue") { Zendesk::ZendeskTickets.new.raise_ticket(ticket) }
  end

private

  def log_queue_sizes
    Sidekiq::Stats.new.queues.each do |queue_name, queue_size|
      GovukStatsd.client.gauge("govuk.app.support.queues.#{queue_name}", queue_size)
    end
  end

  def set_requester_on(request)
    request.requester ||= Support::Requests::Requester.new
    request.requester.name = current_user.name
    request.requester.email = current_user.email
  end
end
