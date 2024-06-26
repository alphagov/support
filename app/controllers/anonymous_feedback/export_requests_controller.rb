require "csv"

class AnonymousFeedback::ExportRequestsController < AuthorisationController
  def create
    authorize! :read, :anonymous_feedback

    set_path_set_id_param

    Services.support_api.create_feedback_export_request(export_request_params)

    redirect_to anonymous_feedback_index_path(anonymous_feedback_params),
                notice: "We are sending your CSV file to #{current_user.email}. If you don't see it in a few minutes, check your spam folder."
  end

  def show
    authorize! :read, :anonymous_feedback

    response = Services.support_api.feedback_export_request(params[:id])
    if response["ready"]
      filename = response["filename"]
      file = get_csv_file_from_s3(filename)
      send_data(file, filename:)
    else
      head :not_found
    end
  end

private

  def set_path_set_id_param
    return if anonymous_feedback_params[:path_set_id].present?

    paths = anonymous_feedback_params[:paths].presence
    return unless paths

    saved_paths = Support::Requests::Anonymous::Paths.new([paths])
    saved_paths.save
    anonymous_feedback_params[:path_set_id] = saved_paths.id
  end

  def export_request_params
    {
      path_prefixes: scope_filters.paths_for_api,
      organisation: scope_filters.organisation_slug,
      from: anonymous_feedback_params[:from],
      to: anonymous_feedback_params[:to],
      notification_email: current_user.email,
    }
  end

  def anonymous_feedback_params
    @anonymous_feedback_params ||= params.permit(:from, :to, :organisation, :path_set_id, :paths).to_h
  end

  def saved_paths
    @saved_paths ||= Support::Requests::Anonymous::Paths.find(anonymous_feedback_params[:path_set_id])
  end

  def paths
    return [] if anonymous_feedback_params[:path_set_id].blank?

    saved_paths.try(:paths)
  end

  def scope_filters
    @scope_filters ||= ScopeFiltersPresenter.new(
      paths:,
      path_set_id: saved_paths.try(:id),
      organisation_slug: anonymous_feedback_params[:organisation],
    )
  end

  def get_csv_file_from_s3(filename)
    s3 = Aws::S3::Client.new
    obj = s3.get_object(bucket: ENV["AWS_S3_BUCKET_NAME"], key: filename)
    obj.body.read
  end
end
