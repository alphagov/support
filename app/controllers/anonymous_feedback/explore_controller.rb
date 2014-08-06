require 'support/requests/anonymous/explore'

class AnonymousFeedback::ExploreController < AuthorisationController
  authorize_resource class: Support::Requests::Anonymous::Explore

  def new
    @explore_by_url = Support::Requests::Anonymous::ExploreByUrl.new
  end

  def create
    @explore_by_url = Support::Requests::Anonymous::ExploreByUrl.new(
      params[:support_requests_anonymous_explore_by_url]
    )
    if @explore_by_url.valid?
      redirect_to @explore_by_url.redirect_path
    else
      render :new, status: 400
    end
  end
end
