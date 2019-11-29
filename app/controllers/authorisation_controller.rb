class AuthorisationController < ApplicationController
  check_authorization

  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      format.html { render "support/forbidden", status: :forbidden }
      format.json { render json: { "error" => "You have not been granted permission to make these requests." }, status: :forbidden }
    end
  end

protected

  def current_ability
    @current_ability ||= Support::Permissions::Ability.new(current_user)
  end
end
