require "gds_api/support_api"

class AnonymousFeedbackController < RequestsController
  include Support::Requests

  def index
    authorize! :read, :anonymous_feedback

    unless has_required_api_params?
      respond_to do |format|
        format.html { redirect_to anonymous_feedback_explore_url, status: 301 }
        format.json { render json: {"errors" => ["Please set a valid 'path' parameter"] }, status: 400 }
      end
      return
    end

    api_response = fetch_anonymous_feedback_from_support_api

    if api_response["pages"] > 0 && api_response["current_page"] > api_response["pages"]
      # assume user has gone past last page, redirect to first page
      redirect_to anonymous_feedback_index_path(index_params.merge(page: 1))
    else
      @feedback = AnonymousFeedbackPresenter.new(api_response)
      @from_date = Date.parse(api_response["from_date"]).to_s(:govuk_date_short) if api_response["from_date"]
      @to_date = Date.parse(api_response["to_date"]).to_s(:govuk_date_short) if api_response["to_date"]

      respond_to do |format|
        format.html
        format.json { render json: @feedback.to_json }
      end
    end
  end

  def set_requester_on(request)
    # this is anonymous feedback, so requester doesn't need to be set
  end

private
  def index_params
    params.permit(:path, :page, :from, :to)
  end

  def api_params
    {
      path_prefix: index_params[:path],
      from: index_params[:from],
      to: index_params[:to],
      page: index_params[:page],
    }.select { |_, value| value.present? }
  end

  def at_least_one_required_api_params
    [
      :path_prefix,
    ]
  end

  def has_required_api_params?
    at_least_one_required_api_params.any? { |required_param|
      api_params[required_param].present?
    }
  end

  def fetch_anonymous_feedback_from_support_api
    support_api.anonymous_feedback(api_params)
  end

  def support_api
    GdsApi::SupportApi.new(Plek.find("support-api"))
  end
end
