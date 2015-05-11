require "gds_api/support_api"

class AnonymousFeedbackController < RequestsController
  include Support::Requests

  def index
    authorize! :read, Anonymous::AnonymousContact

    if params[:path].nil? or params[:path].empty?
      redirect_to anonymous_feedback_explore_url, status: 301
    else
      @feedback = anonymous_feedback(index_params)
    end
  end

  def set_requester_on(request)
    # this is anonymous feedback, so requester doesn't need to be set
  end

private
  def anonymous_feedback(options)
    AnonymousFeedbackPresenter.new(
      support_api.get_anonymous_feedback(options),
    )
  end

  def index_params
    {
      starting_with_path: params[:path],
      page: params[:page],
    }
  end

  def support_api
    GdsApi::SupportApi.new(Plek.find("support-api"))
  end
end
