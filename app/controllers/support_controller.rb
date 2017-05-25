require 'sidekiq/api'

class SupportController < AuthorisationController
  skip_authorization_check
  skip_before_action :authenticate_support_user!, only: [:queue_status]

  def landing
    all_sections = Support::Navigation::SectionGroups.new(current_user).all_sections +
      [ Support::Navigation::FeedexSection.new(current_user), Support::Navigation::EmergencyContactDetailsSection.new(current_user) ]
    @accessible_sections, @inaccessible_sections = all_sections.partition(&:accessible?)
  end

  def emergency_contact_details
    @primary_contact_details = EMERGENCY_CONTACT_DETAILS[:primary_contacts]
    @secondary_contact_details = EMERGENCY_CONTACT_DETAILS[:secondary_contacts]
    @current_at = Date.parse(EMERGENCY_CONTACT_DETAILS[:current_at])
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
      status[:queues][queue_name] = {"jobs" => queue_size}
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
