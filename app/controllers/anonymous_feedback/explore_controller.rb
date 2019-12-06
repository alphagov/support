require "gds_api/support_api"

class AnonymousFeedback::ExploreController < AuthorisationController
  include ExploreHelper

  authorize_resource class: Support::Requests::Anonymous::Explore

  def new
    @explore_by_multiple_paths = Support::Requests::Anonymous::ExploreByMultiplePaths.new
    @explore_by_organisation = Support::Requests::Anonymous::ExploreByOrganisation.new(organisation: current_user.organisation_slug)
    @organisations_list = parse_organisations(support_api.organisations_list)
    @explore_by_document_type = Support::Requests::Anonymous::ExploreByDocumentType.new
    @document_type_list = parse_doctypes(support_api.document_type_list)
  end

  def create
    @explore = if params[:support_requests_anonymous_explore_by_multiple_paths].present?
                 Support::Requests::Anonymous::ExploreByMultiplePaths.new(
                   explore_by_multiple_path_params,
                 )
               elsif params[:support_requests_anonymous_explore_by_document_type].present?
                 Support::Requests::Anonymous::ExploreByDocumentType.new(
                   explore_by_document_type_params,
                 )
               else
                 Support::Requests::Anonymous::ExploreByOrganisation.new(
                   explore_by_organisation_params,
                 )
               end

    if @explore.valid?
      redirect_to @explore.redirect_path
    else
      new
      render :new, status: :unprocessable_entity
    end
  end

private

  def support_api
    GdsApi::SupportApi.new(
      Plek.find("support-api"),
      bearer_token: ENV["SUPPORT_API_BEARER_TOKEN"],
    )
  end

  # TODO: explicitly permit the right set of params, rather than everything
  def explore_by_multiple_path_params
    params.require(:support_requests_anonymous_explore_by_multiple_paths).permit!.to_h
  end

  def explore_by_organisation_params
    params.require(:support_requests_anonymous_explore_by_organisation).permit!.to_h
  end

  def explore_by_document_type_params
    params.require(:support_requests_anonymous_explore_by_document_type).permit!.to_h
  end
end
