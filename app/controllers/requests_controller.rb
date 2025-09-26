require "sidekiq/api"

class RequestsController < AuthorisationController
  include ErrorsHelper
  include NameHelper

  def new
    @request = new_request
    authorize! :new, @request

    render :new, layout: "design_system" if @use_design_system
  end

  def create
    @request = parse_request_from_params
    authorize! :create, @request
    set_requester_on(@request)

    if @request.valid?
      save_to_zendesk(@request)
      respond_to do |format|
        format.html do
          if params[:use_design_system]
            flash[:success_alert] = {
              message: "Thank you!",
              description: "Thanks for sending us your request. We'll review your request and get back to you within 2 working days.",
            }
            redirect_to root_path
          else
            redirect_to acknowledge_path
          end
        end
        format.json { head :created }
      end
    else
      respond_to do |format|
        format.html do
          if params[:use_design_system]
            @use_design_system = true
            render :new, status: :bad_request, layout: "design_system"
          else
            flash.now[:alert] = @request.errors.full_messages.join('\n')
            render :new, status: :bad_request
          end
        end
        format.json { render json: { "errors" => @request.errors.to_a }, status: :bad_request }
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
