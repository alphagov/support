class AnonymousFeedback::OrganisationsController < AuthorisationController
  def show
    authorize! :read, :anonymous_feedback

    @ordering = if %w[path last_7_days last_30_days last_90_days].include? params[:ordering]
                  params[:ordering]
                else
                  "last_7_days"
                end

    api_response = fetch_organisation_summary_from_support_api(@ordering)

    @organisation = OrganisationPresenter.new(api_response)
    @content_items = OrganisationSummaryPresenter.new(api_response)
  end

private

  def fetch_organisation_summary_from_support_api(ordering)
    Services.support_api.organisation_summary(params[:slug], ordering:)
  end
end
