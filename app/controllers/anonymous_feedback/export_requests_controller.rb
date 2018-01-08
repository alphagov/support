require 'gds_api/support_api'
require 'csv'

class AnonymousFeedback::ExportRequestsController < AuthorisationController
  def create
    authorize! :read, :anonymous_feedback

    support_api.create_feedback_export_request(export_request_params)
    redirect_to anonymous_feedback_index_path(anonymous_feedback_params),
                notice: "We are sending your CSV file to #{current_user.email}. If you don't see it in a few minutes, check your spam folder."
  end

  def show
    authorize! :read, :anonymous_feedback

    response = support_api.feedback_export_request(params[:id])
    if response["ready"]
      send_file "/data/uploads/support-api/csvs/#{response['filename']}"
    else
      head :not_found
    end
  end

private

  def export_request_params
    {
      path_prefixes: scope_filters.paths_for_api,
      organisation: scope_filters.organisation_slug,
      from: anonymous_feedback_params[:from],
      to: anonymous_feedback_params[:to],
      notification_email: current_user.email
    }
  end

  def anonymous_feedback_params
    clean_paths
    @anonymous_feedback_params ||= params.permit(:from, :to, :organisation, :path, paths: []).to_h
  end

  def clean_paths
    if params[:path]
      params[:paths] = [params[:path]]
    elsif params[:paths] && params[:paths].instance_of?(String)
      params[:paths] = params[:paths].split(',').map(&:strip)
    end
  end

  def scope_filters
    @scope_filters ||= ScopeFiltersPresenter.new(paths: anonymous_feedback_params[:paths], organisation_slug: anonymous_feedback_params[:organisation])
  end

  def support_api
    GdsApi::SupportApi.new(Plek.find("support-api"))
  end
end
