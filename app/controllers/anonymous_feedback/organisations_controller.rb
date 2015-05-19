require "gds_api/support_api"

class AnonymousFeedback::OrganisationsController < AuthorisationController
  def show
    authorize! :read, :anonymous_feedback

    feedback = fetch_organisation_summary_from_support_api
    @organisation_title = feedback["title"]
    @content_items = feedback["results"].map { |content_item|
      OpenStruct.new(content_item)
    }.sort_by(&:path)
  end

private
  def fetch_organisation_summary_from_support_api
    support_api.organisation_summary(params[:slug])
  end

  def support_api
    GdsApi::SupportApi.new(Plek.find("support-api"))
  end
end
