require 'sidekiq'
require 'support/navigation/feedex_section'
require 'support/navigation/emergency_contact_details_section'

class SupportController < AuthorisationController
  include Support::Navigation

  skip_authorization_check
  skip_before_filter :authenticate_support_user!, only: [:queue_status]

  def landing
    all_sections = SectionGroups.new(current_user).all_sections +
      [ FeedexSection.new(current_user), EmergencyContactDetailsSection.new(current_user) ]
    @accessible_sections, @inaccessible_sections = all_sections.partition(&:accessible?)
  end

  def emergency_contact_details
    @primary_contact_details = EMERGENCY_CONTACT_DETAILS[:primary_contacts]
    @secondary_contact_details = EMERGENCY_CONTACT_DETAILS[:secondary_contacts]
    @current_at = EMERGENCY_CONTACT_DETAILS[:current_at]
  end

  def acknowledge
    respond_to do |format|
      format.html { render :acknowledge }
      format.json { render nothing: true }
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
        render nothing: true, status: 406
      end
    end
  end
end
