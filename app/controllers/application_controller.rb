class ApplicationController < ActionController::Base
  include GDS::SSO::ControllerMethods
  
  before_filter :authenticate_user!
  
  protect_from_forgery

  protected
  def exception_notification_for(e)
    if e.respond_to?(:errors)
      message = { data: { message: "Zendesk errors: #{e.errors}" } }
      ExceptionNotifier::Notifier.exception_notification(request.env, e, message).deliver
    else
      ExceptionNotifier::Notifier.exception_notification(request.env, e).deliver
    end
  end
end
