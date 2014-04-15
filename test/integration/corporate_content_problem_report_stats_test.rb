require 'test_helper'
require 'time'
require 'json'
require 'gds_api/test_helpers/performance_platform/data_in'

class CorporateContentProblemReportStatsTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::PerformancePlatform::DataIn

  test "corporate content for the previous month is pushed to the performance platform" do
    stub_post1 = stub_corporate_content_problem_report_count_submission([
      {
        "_id" => "201301_dft",
        "_timestamp" => "2013-01-01T00:00:00+00:00",
        "period" => "month",
        "organisation_acronym" => "dft",
        "comment_count" => 1,
        "total_gov_uk_dept_and_policy_comment_count" => 1
      }
    ])
    stub_post2 = stub_corporate_content_urls_with_the_most_problem_reports_submission([
      {
        "_id" => "201301_dft_1",
        "_timestamp" => "2013-01-01T00:00:00+00:00",
        "period" => "month",
        "organisation_acronym" => "dft",
        "comment_count" => 1,
        "url" => "https://www.gov.uk/abc"
      }
    ])

    Timecop.travel Time.parse("2013-01-15 12:00:00")

    create_problem_report_with(
      what_wrong: "this service is great",
      url: "https://www.gov.uk/abc",
      page_owner: "dft"
    )

    Timecop.travel Time.parse("2013-02-01 12:00:00")

    ProblemReportStatsPPUploaderWorker.run

    assert_requested(stub_post1)
    assert_requested(stub_post2)
  end

  def teardown
    Timecop.return
  end

  def create_problem_report_with(options)
    defaults = { javascript_enabled: true }
    Support::Requests::Anonymous::ProblemReport.create!(defaults.merge(options))
  end
end
