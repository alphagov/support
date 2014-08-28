require 'gds_api/performance_platform/data_in'
require 'support/requests/anonymous/corporate_content_problem_report_aggregated_metrics'

class ProblemReportStatsPPUploaderWorker
  include Sidekiq::Worker
  include Support::Requests::Anonymous

  def perform(year, month)
    logger.info("Uploading corporate content problem report statistics for #{year}-#{month}")
    api = GdsApi::PerformancePlatform::DataIn.new(
      PP_DATA_IN_API[:url],
      bearer_token: PP_DATA_IN_API[:bearer_token]
    )
    stats = CorporateContentProblemReportAggregatedMetrics.new(year, month).to_h
    response = api.corporate_content_problem_report_count(stats["feedback_counts"])
    logger.info "Feedback counts push response: #{response.code}"
    response = api.corporate_content_urls_with_the_most_problem_reports(stats["top_urls"])
    logger.info "Top URLs counts push response: #{response.code}"
  end

  def self.run
    first_day_of_last_month = Date.today.prev_month.at_beginning_of_month
    perform_async(first_day_of_last_month.year, first_day_of_last_month.month)
    logger.info("Queued problem reports stats upload for month #{first_day_of_last_month.year}-#{first_day_of_last_month.month}")
  end
end
