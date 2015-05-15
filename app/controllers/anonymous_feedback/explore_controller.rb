require 'support/requests/anonymous/explore'
require 'gds_api/organisations'

class AnonymousFeedback::ExploreController < AuthorisationController
  authorize_resource class: Support::Requests::Anonymous::Explore

  def new
    @explore_by_url = Support::Requests::Anonymous::ExploreByUrl.new
    @explore_by_organisation = Support::Requests::Anonymous::ExploreByOrganisation.new
    @organisations_list = organisations_api.organisations.map { |org|
      [org.title, org.details.slug]
    }
  end

  def create
    if params[:support_requests_anonymous_explore_by_url].present?
      @explore = Support::Requests::Anonymous::ExploreByUrl.new(
        params[:support_requests_anonymous_explore_by_url]
      )
    else
      @explore = Support::Requests::Anonymous::ExploreByOrganisation.new(
        params[:support_requests_anonymous_explore_by_organisation]
      )
    end

    if @explore.valid?
      redirect_to @explore.redirect_path
    else
      render :new, status: 422
    end
  end

private
  def organisations_api
    GdsApi::Organisations.new(Plek.current.find("whitehall-admin"))
  end
end
