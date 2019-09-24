require "gds_api/support_api"

class AnonymousFeedback::ProblemReportsController < AuthorisationController
  def index
    authorize! :request, :review_feedback

    api_response = fetch_problem_reports

    @feedback = AnonymousFeedbackPresenter.new(api_response)
    @dates = present_date_filters(api_response)
  end

  def review
    authorize! :request, :review_feedback

    if review_params.any? && reviewed_items_successfully?
      redirect_to anonymous_feedback_problem_reports_path(anonymous_feedback_problem_report_params)
    else
      flash.now[:alert] = "Something went wrong with this review"
      render :index, status: 400
    end
  end

private

  def anonymous_feedback_problem_report_params
    params.permit(:to_date, :from_date, :include_reviewed).to_h
  end

  def fetch_problem_reports
    AnonymousFeedbackApiResponse.new(
      support_api.problem_reports(api_params).to_hash,
    )
  end

  def api_params
    {
      include_reviewed: !!index_params[:include_reviewed],
      page: index_params[:page],
      from_date: index_params[:from_date],
      to_date: index_params[:to_date],
    }.select { |_, value| value.present? }
  end

  def support_api
    GdsApi::SupportApi.new(
      Plek.find("support-api"),
      bearer_token: ENV["SUPPORT_API_BEARER_TOKEN"],
    )
  end

  def index_params
    params.permit(:page, :from_date, :to_date, :include_reviewed).to_h
  end

  def present_date_filters(api_response)
    DateFiltersPresenter.new(
      requested_from: index_params[:from_date],
      requested_to: index_params[:to_date],
      actual_from: api_response.from_date,
      actual_to: api_response.to_date,
    )
  end

  def review_params
    params.require(:mark_as_spam).permit!.to_h
  end

  def reviewed_items_successfully?
    support_api.mark_reviewed_for_spam(review_params).code == 200
  end
end
