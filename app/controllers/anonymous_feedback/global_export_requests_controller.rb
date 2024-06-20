class AnonymousFeedback::GlobalExportRequestsController < AuthorisationController
  def create
    authorize! :request, :global_export_request

    Services.support_api.create_global_export_request(export_request_params)
    redirect_to anonymous_feedback_explore_path,
                notice: "We are sending your CSV file to #{current_user.email}. If you don't see it in a few minutes, check your spam folder."
  end

private

  def export_request_params
    params
      .permit(:from_date, :to_date)
      .to_h
      .merge(
        notification_email: current_user.email,
        exclude_spam: exclude_spam?,
      )
  end

  def exclude_spam?
    params[:exclude_spam].present?
  end
end
