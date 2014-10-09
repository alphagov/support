require 'rails_helper'
require 'time'
require 'json'
require 'gds_api/test_helpers/performance_platform/data_in'

describe "corporate content problem report stats" do
  include GdsApi::TestHelpers::PerformancePlatform::DataIn

  it "is pushed to the performance platform for the previous month" do
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
        "url" => "http://www.dev.gov.uk/abc"
      }
    ])

    Timecop.travel Time.parse("2013-01-15 12:00:00")

    create(:problem_report,
      what_wrong: "this service is great",
      path: "/abc",
      page_owner: "dft"
    )

    Timecop.travel Time.parse("2013-02-01 12:00:00")

    ProblemReportStatsPPUploaderWorker.run

    expect(stub_post1).to have_been_made
    expect(stub_post2).to have_been_made
  end

  after do
    Timecop.return
  end
end
