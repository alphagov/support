require "gds_api/support_api"

class AnonymousFeedback::OrganisationsController < AuthorisationController
  def show
    authorize! :read, :anonymous_feedback

    api_response = fetch_organisation_summary_from_support_api

    @organisation_title = api_response["title"]
    @content_items = OrganisationSummaryPresenter.new(api_response)
  end

private
  def fetch_organisation_summary_from_support_api
    support_api.organisation_summary(params[:slug])
  end

  def support_api
    GdsApi::SupportApi.new(Plek.find("support-api"))
  end
end
