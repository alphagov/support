class AnonymousFeedbackController < RequestsController
  include Support::Requests

  def index
    authorize! :read, Anonymous::AnonymousContact

    if params[:path].nil? or params[:path].empty?
      respond_to do |format|
        format.html { redirect_to anonymous_feedback_explore_url, status: 301 }
        format.json { render json: {"errors" => ["Please set a valid 'path' parameter"] }, status: 400 }
      end
    else
      @feedback = Anonymous::AnonymousContact.
        find_all_starting_with_path(params[:path]).
        page(params[:page])
      respond_to do |format|
        format.html
        format.json
      end
    end
  end

  def set_requester_on(request)
    # this is anonymous feedback, so requester doesn't need to be set
  end
end
