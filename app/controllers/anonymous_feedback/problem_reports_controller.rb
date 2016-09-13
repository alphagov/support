require "gds_api/support_api"

class AnonymousFeedback::ProblemReportsController < AuthorisationController
  def index
    authorize! :request, :review_feedback

    api_response = fetch_problem_reports

    @feedback = AnonymousFeedbackPresenter.new(api_response)
    @dates = present_date_filters(api_response)
  end

  private

  def fetch_problem_reports
    AnonymousFeedbackApiResponse.new(
      support_api.problem_reports(api_params).to_hash
    )
  end

  def api_params
    {
      include_reviewed: !!index_params[:include_reviewed],
      page: index_params[:page],
      from_date: index_params[:from_date],
      to_date: index_params[:to_date]
    }.select { |_, value| value.present? }
  end

  def support_api
    @api ||= GdsApi::SupportApi.new(Plek.find("support-api"))
  end

  def index_params
    params.permit(:page, :from_date, :to_date, :include_reviewed)
  end

  def present_date_filters(api_response)
    DateFiltersPresenter.new(
      requested_from: index_params[:from_date],
      requested_to: index_params[:to_date],
      actual_from: api_response.from_date,
      actual_to: api_response.to_date,
    )
  end
end
