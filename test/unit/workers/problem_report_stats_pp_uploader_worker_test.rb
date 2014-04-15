require 'test_helper'
require 'date'
require 'gds_api/test_helpers/performance_platform/data_in'

class ProblemReportStatsPPUploaderWorkerTest < ActiveSupport::TestCase
  include Support::Requests::Anonymous
  include GdsApi::TestHelpers::PerformancePlatform::DataIn

  should "push last month's problem report stats for Whitehall content (aggregated by org) to the performance platform" do
    Date.stubs(:today).returns(Date.new(2013,2,1))

    CorporateContentProblemReportAggregatedMetrics.stubs(:new).with(2013,1).returns(
      stub(to_h: { "feedback_counts" => [ :some, :counts ], "top_urls" => [ :some, :top, :urls ] })
    )

    stub_post1 = stub_corporate_content_problem_report_count_submission([ :some, :counts ])
    stub_post2 = stub_corporate_content_urls_with_the_most_problem_reports_submission([ :some, :top, :urls ])

    ProblemReportStatsPPUploaderWorker.run

    assert_requested(stub_post1)
    assert_requested(stub_post2)
  end
end
