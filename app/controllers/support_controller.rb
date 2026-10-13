require "sidekiq/api"
class SupportController < AuthorisationController
  skip_authorization_check
  skip_before_action :authenticate_support_user!, only: [:queue_status]

  def landing
    @accessible_sections, @inaccessible_sections =
      Support::Navigation::Sections.new(current_user).partition(&:accessible?)

    render :landing, layout: "design_system"
  end

  def acknowledge
    respond_to do |format|
      format.html { render :acknowledge }
      format.json { head :ok }
    end
  end

  def queue_status
    status = { queues: {} }

    Sidekiq::Stats.new.queues.each do |queue_name, queue_size|
      status[:queues][queue_name] = { "jobs" => queue_size }
    end

    respond_to do |format|
      format.json do
        render json: status
      end
      format.any do
        head :not_acceptable
      end
    end
  end
end
