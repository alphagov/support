require 'support/requests/anonymous/explore'
require 'gds_api/organisations'

class AnonymousFeedback::ExploreController < AuthorisationController
  authorize_resource class: Support::Requests::Anonymous::Explore

  def new
    @explore_by_url = Support::Requests::Anonymous::ExploreByUrl.new
    @organisations_list = organisations_api.organisations.map { |org|
      [org.title, org.details.slug]
    }
  end

  def create
    @explore_by_url = Support::Requests::Anonymous::ExploreByUrl.new(
      params[:support_requests_anonymous_explore_by_url]
    )
    if @explore_by_url.valid?
      redirect_to @explore_by_url.redirect_path
    else
      render :new, status: 422
    end
  end

private
  def organisations_api
    GdsApi::Organisations.new(Plek.current.find("whitehall-admin"))
  end
end
