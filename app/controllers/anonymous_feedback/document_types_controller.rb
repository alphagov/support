class AnonymousFeedback::DocumentTypesController < AuthorisationController
  def show
    authorize! :read, :anonymous_feedback

    @ordering = if %w[path last_7_days last_30_days last_90_days].include? params[:ordering]
                  params[:ordering]
                else
                  "last_7_days"
                end

    api_response = fetch_document_type_summary_from_support_api(@ordering)

    @document_type = DocumentTypePresenter.new(api_response)
    @content_items = DocumentTypeSummaryPresenter.new(api_response)
  end

private

  def fetch_document_type_summary_from_support_api(ordering)
    Services.support_api.document_type_summary(params[:document_type], ordering:)
  end
end
