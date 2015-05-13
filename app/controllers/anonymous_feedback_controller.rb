require "gds_api/support_api"

class AnonymousFeedbackController < RequestsController
  include Support::Requests

  def index
    authorize! :read, Anonymous::AnonymousContact

    if index_params[:path].nil? or index_params[:path].empty?
      respond_to do |format|
        format.html { redirect_to anonymous_feedback_explore_url, status: 301 }
        format.json { render json: {"errors" => ["Please set a valid 'path' parameter"] }, status: 400 }
      end
    else
      api_response = fetch_anonymous_feedback_from_support_api

      if api_response["pages"] > 0 && api_response["current_page"] > api_response["pages"]
        # assume user has gone past last page, redirect to first page
        redirect_to anonymous_feedback_index_path(index_params.merge(page: 1))
      else
        @feedback = AnonymousFeedbackPresenter.new(api_response)

        respond_to do |format|
          format.html
          format.json { render json: @feedback.to_json }
        end
      end
    end
  end

  def set_requester_on(request)
    # this is anonymous feedback, so requester doesn't need to be set
  end

private
  def index_params
    params.permit(:path, :page)
  end

  def fetch_anonymous_feedback_from_support_api
    api_params = { path_prefix: index_params[:path] }
    api_params[:page] = index_params[:page] if index_params[:page]
    support_api.anonymous_feedback(api_params)
  end

  def support_api
    GdsApi::SupportApi.new(Plek.find("support-api"))
  end
end
