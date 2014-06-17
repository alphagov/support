require 'rails_helper'
require 'date'
require 'gds_api/test_helpers/performance_platform/data_in'

describe ProblemReportStatsPPUploaderWorker do
  include GdsApi::TestHelpers::PerformancePlatform::DataIn

  it "pushes last month's problem report stats for Whitehall content (aggregated by org) to the performance platform" do
    Timecop.travel Date.new(2013,2,1)

    allow(Support::Requests::Anonymous::CorporateContentProblemReportAggregatedMetrics).to receive(:new).with(2013,1).and_return(
      double(to_h: { "feedback_counts" => [ :some, :counts ], "top_urls" => [ :some, :top, :urls ] })
    )

    stub_post1 = stub_corporate_content_problem_report_count_submission([ :some, :counts ])
    stub_post2 = stub_corporate_content_urls_with_the_most_problem_reports_submission([ :some, :top, :urls ])

    ProblemReportStatsPPUploaderWorker.run

    expect(stub_post1).to have_been_made
    expect(stub_post2).to have_been_made
  end
end
