require "gds_api/support_api"

class AnonymousFeedback::GlobalExportRequestsController < AuthorisationController
  def create
    authorize! :request, :global_export_request

    support_api.create_global_export_request(export_request_params)
    redirect_to anonymous_feedback_explore_path,
      notice: "We are sending your CSV file to #{current_user.email}. If you don't see it in a few minutes, check your spam folder."
  end

private

  def export_request_params
    params.
      permit(:from_date, :to_date).
      to_h.
      merge(
        notification_email: current_user.email,
        exclude_spam: exclude_spam?
      )
  end

  def support_api
    GdsApi::SupportApi.new(Plek.find("support-api"))
  end

  def exclude_spam?
    !!params.permit(:exclude_spam)
  end
end
