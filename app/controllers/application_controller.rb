require "timeout"

class ApplicationController < ActionController::Base
  include GDS::SSO::ControllerMethods

  before_action :authenticate_support_user!

  protect_from_forgery

  rescue_from Timeout::Error, with: :service_unavailable

protected

  def exception_notification_for(exception)
    exception_class_name = exception.class.name.demodulize.downcase
    GovukStatsd.increment("exception.#{exception_class_name}")
    GovukError.notify(exception)
  end

  def authenticate_support_user!
    Timeout::timeout(default_timeout_in_seconds) {
      GovukStatsd.client.time("timings.authentication") { authenticate_user! }
    }
  end

  def service_unavailable
    GovukStatsd.increment("authentication_timeout")
    head :service_unavailable
  end

  def default_timeout_in_seconds
    3
  end
end
