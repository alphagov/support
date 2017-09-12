class AuthorisationController < ApplicationController
  check_authorization

  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      format.html { render "support/forbidden", status: 403 }
      format.json { render json: { "error" => "You have not been granted permission to make these requests." }, status: 403 }
    end
  end

protected

  def current_ability
    @current_ability ||= Support::Permissions::Ability.new(current_user)
  end
end
