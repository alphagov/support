require 'date'
require 'gds_api/performance_platform/data_in'
require 'support/requests/anonymous/service_feedback_aggregated_metrics'

class ServiceFeedbackPPUploaderWorker
  include Sidekiq::Worker
  include Support::Requests::Anonymous

  def perform(year, month, day, transaction_slug)
    Rails.logger.info("Uploading statistics for #{year}-#{month}-#{day}, slug #{transaction_slug}")
    api = GdsApi::PerformancePlatform::DataIn.new(
      PP_DATA_IN_API[:url],
      bearer_token: PP_DATA_IN_API[:bearer_token]
    )
    request_details = ServiceFeedbackAggregatedMetrics.new(Date.new(year, month, day), transaction_slug).to_h
    api.submit_service_feedback_day_aggregate(transaction_slug, request_details)
  end

  def self.run
    yesterday = Date.yesterday
    slugs = Support::Requests::Anonymous::ServiceFeedback.transaction_slugs
    slugs.each do |transaction_slug|
      perform_async(yesterday.year, yesterday.month, yesterday.day, transaction_slug)
    end
    Rails.logger.info("Queued upload for #{slugs.size} slugs")
  end
end
