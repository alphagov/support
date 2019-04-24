require "gds_api/support_api"

class AnonymousFeedbackController < RequestsController
  include ExploreHelper

  def index
    authorize! :read, :anonymous_feedback

    return unless validate_required_api_params

    api_response = fetch_anonymous_feedback_from_support_api

    if api_response.beyond_last_page?
      redirect_to first_page
      return
    end

    respond_to do |format|
      format.html {
        @feedback = AnonymousFeedbackPresenter.new(api_response)
        @dates = present_date_filters(api_response)
        # TODO: I guess we should determine this filtering information from the
        # api_response rather than user-supplied params (note it's not
        # currently available on the api_response)
        @filtered_by = scope_filters
        @organisations_list = parse_organisations(support_api.organisations_list)
        @document_type_list = parse_doctypes(support_api.document_type_list)
      }
      format.json { render json: api_response.results }
    end
  end

  def create
    authorize! :read, :anonymous_feedback

    return unless validate_required_api_params

    saved_paths = Support::Requests::Anonymous::Paths.new(scope_filters.paths_for_api)
    saved_paths.save

    index_params[:paths] = saved_paths.id
    redirect_to anonymous_feedback_index_path(index_params)
  end

  def set_requester_on(request)
    # this is anonymous feedback, so requester doesn't need to be set
  end

private

  def validate_required_api_params
    return true if has_required_api_params?

    respond_to do |format|
      format.html { redirect_to anonymous_feedback_explore_url, status: 301 }
      format.json { render json: { "errors" => ["Please provide a valid 'paths', 'path' or 'organisation' parameter"] }, status: 400 }
    end

    false
  end

  def index_params
    clean_paths
    @index_params ||= params.permit(:organisation, :document_type, :page, :from, :to, paths: []).to_h
  end

  def clean_paths
    if params[:path].present?
      params[:paths] = [params[:path]]
    elsif params[:paths] && params[:paths].instance_of?(String)
      saved_paths = Support::Requests::Anonymous::Paths.find(params[:paths])
      params[:paths] = saved_paths.try(:paths) || params[:paths].split(',').map(&:strip)
    end
  end

  def scope_filters
    @scope_filters ||= ScopeFiltersPresenter.new(paths: index_params[:paths], organisation_slug: index_params[:organisation], document_type: index_params[:document_type])
  end

  def present_date_filters(api_response)
    DateFiltersPresenter.new(
      requested_from: index_params[:from],
      requested_to: index_params[:to],
      actual_from: api_response.from_date,
      actual_to: api_response.to_date,
    )
  end

  def first_page
    anonymous_feedback_index_path(index_params.merge(page: 1))
  end

  def api_params
    {
      path_prefixes: scope_filters.paths_for_api,
      organisation_slug: scope_filters.organisation_slug,
      document_type: scope_filters.document_type,
      from: index_params[:from],
      to: index_params[:to],
      page: index_params[:page],
    }.select { |_, value| value.present? }
  end

  def at_least_one_required_api_params
    %i[
      path_prefixes
      organisation_slug
      document_type
    ]
  end

  def has_required_api_params?
    at_least_one_required_api_params.any? { |required_param|
      api_params[required_param].present?
    }
  end

  def fetch_anonymous_feedback_from_support_api
    AnonymousFeedbackApiResponse.new(
      support_api.anonymous_feedback(api_params).to_hash
    )
  end

  def support_api
    GdsApi::SupportApi.new(
      Plek.find("support-api"),
      bearer_token: ENV["SUPPORT_API_BEARER_TOKEN"],
    )
  end
end
