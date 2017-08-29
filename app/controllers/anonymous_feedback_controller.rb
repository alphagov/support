require "gds_api/support_api"

class AnonymousFeedbackController < RequestsController
  def index
    authorize! :read, :anonymous_feedback

    unless has_required_api_params?
      respond_to do |format|
        format.html { redirect_to anonymous_feedback_explore_url, status: 301 }
        format.json { render json: {"errors" => ["Please set a valid 'path' or 'organisation' parameter"] }, status: 400 }
      end
      return
    end

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
        @filtered_by = ScopeFiltersPresenter.new(path: api_params[:path_prefix], organisation_slug: api_params[:organisation_slug])
        @organisations_list = support_api.organisations_list.map do |org|
          [organisation_title_for_select(org), org["slug"]]
        end
      }
      format.json { render json: api_response.results }
    end
  end

  def set_requester_on(request)
    # this is anonymous feedback, so requester doesn't need to be set
  end

private
  def index_params
    params.permit(:path, :organisation, :page, :from, :to).to_h
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
      path_prefix: index_params[:path],
      organisation_slug: index_params[:organisation],
      from: index_params[:from],
      to: index_params[:to],
      page: index_params[:page],
    }.select { |_, value| value.present? }
  end

  def at_least_one_required_api_params
    [
      :path_prefix,
      :organisation_slug,
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
    GdsApi::SupportApi.new(Plek.find("support-api"))
  end

  def organisation_title_for_select(organisation)
    title = organisation["title"]
    title << " (#{organisation["acronym"]})" if organisation["acronym"].present?
    title << " [#{organisation["govuk_status"].titleize}]" if organisation["govuk_status"] && organisation["govuk_status"] != "live"
    title
  end
end
