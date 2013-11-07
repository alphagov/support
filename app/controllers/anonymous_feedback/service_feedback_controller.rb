require 'support/requests/anonymous/service_feedback'

class AnonymousFeedback::ServiceFeedbackController < AnonymousFeedbackController
  include Support::Requests::Anonymous

  protected
  def persistence_to_zendesk_necessary?
    false
  end

  def parse_request_from_params
    # remapping improvement_comments => details
    params[:service_feedback][:details] ||= params[:service_feedback][:improvement_comments]
    ServiceFeedback.new(params[:service_feedback])
  end
end
