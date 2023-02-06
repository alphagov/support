class AuthorisationController < ApplicationController
  before_action :emergency_contact_details

  check_authorization

  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      format.html { render "support/forbidden", status: :forbidden }
      format.json { render json: { "error" => "You have not been granted permission to make these requests." }, status: :forbidden }
    end
  end

  def emergency_contact_details
    emergency_contact_details = EmergencyContactDetails.fetch
    @primary_contact_details = emergency_contact_details[:primary_contacts]
    @secondary_contact_details = emergency_contact_details[:secondary_contacts]
    @verify_contact_details = emergency_contact_details[:verify_contacts]
    @current_at = Date.parse(emergency_contact_details[:current_at])
  end

protected

  def current_ability
    @current_ability ||= Support::Permissions::Ability.new(current_user)
  end
end
