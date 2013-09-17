class ApplicationController < ActionController::Base
  include GDS::SSO::ControllerMethods
  
  before_filter :authenticate_support_user!
  
  protect_from_forgery

  protected
  def exception_notification_for(e)
    exception_class_name = e.class.name.demodulize.downcase
    $statsd.increment("#{::STATSD_PREFIX}.exception.#{exception_class_name}")

    if e.respond_to?(:errors)
      message = { data: { message: "Zendesk errors: #{e.errors}" } }
      ExceptionNotifier::Notifier.exception_notification(request.env, e, message).deliver
    else
      ExceptionNotifier::Notifier.exception_notification(request.env, e).deliver
    end
  end

  def authenticate_support_user!
    $statsd.time("#{::STATSD_PREFIX}.timings.authentication") { authenticate_user! }
  end
end
