require 'timeout'

class ApplicationController < ActionController::Base
  include GDS::SSO::ControllerMethods

  before_filter :authenticate_support_user!

  protect_from_forgery

  rescue_from Timeout::Error, with: :service_unavailable

  protected
  def exception_notification_for(e)
    exception_class_name = e.class.name.demodulize.downcase
    $statsd.increment("#{::STATSD_PREFIX}.exception.#{exception_class_name}")
    notify_airbrake(e)
  end

  def authenticate_support_user!
    Timeout::timeout(default_timeout_in_seconds) {
      $statsd.time("#{::STATSD_PREFIX}.timings.authentication") { authenticate_user! }
    }
  end

  def service_unavailable
    $statsd.increment("#{::STATSD_PREFIX}.authentication_timeout")
    render nothing: true, status: 503
  end

  def default_timeout_in_seconds
    3
  end
end
