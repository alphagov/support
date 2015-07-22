require 'support/requests/anonymous/explore'
require 'gds_api/support_api'

class AnonymousFeedback::ExploreController < AuthorisationController
  authorize_resource class: Support::Requests::Anonymous::Explore

  def new
    @explore_by_url = Support::Requests::Anonymous::ExploreByUrl.new
    @explore_by_organisation = Support::Requests::Anonymous::ExploreByOrganisation.new(organisation: current_user.organisation_slug)
    @organisations_list = support_api.organisations_list.map do |org|
      [organisation_title(org), org["slug"]]
    end
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
      new
      render :new, status: 422
    end
  end

private
  def support_api
    GdsApi::SupportApi.new(Plek.find("support-api"))
  end

  def organisation_title(organisation)
    title = organisation["title"]
    title << " (#{organisation["acronym"]})" if organisation["acronym"].present?
    title << " [#{organisation["govuk_status"].titleize}]" if organisation["govuk_status"] && organisation["govuk_status"] != "live"
    title
  end
end
