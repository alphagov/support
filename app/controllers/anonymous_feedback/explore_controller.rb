require 'support/requests/anonymous/explore'

class AnonymousFeedback::ExploreController < AuthorisationController
  authorize_resource class: Support::Requests::Anonymous::Explore

  def new
    @explore = Support::Requests::Anonymous::Explore.new
  end

  def create
    @explore = Support::Requests::Anonymous::Explore.new(params[:support_requests_anonymous_explore])
    if @explore.valid?
      redirect_to anonymous_feedback_index_url(path: @explore.path)
    else
      render :new, status: 400
    end
  end
end
