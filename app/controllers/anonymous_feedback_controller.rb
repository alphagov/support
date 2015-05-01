class AnonymousFeedbackController < RequestsController
  include Support::Requests

  def index
    authorize! :read, Anonymous::AnonymousContact

    if params[:path].nil? or params[:path].empty?
      redirect_to anonymous_feedback_explore_url, status: 301
    else
      @feedback = Anonymous::AnonymousContact.
        find_all_starting_with_path(params[:path]).
        page(params[:page])
    end
  end

  def set_requester_on(request)
    # this is anonymous feedback, so requester doesn't need to be set
  end
end
