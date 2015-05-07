require 'rails_helper'
require 'gds_api/test_helpers/support_api'

feature "Exploring anonymous feedback" do
  include GdsApi::TestHelpers::SupportApi

  background do
    login_as create(:user)
  end

  scenario "exploring feedback by URL" do
    data = {
      "current_page" => 1,
      "pages" => 1,
      "page_size" => 2,
      "results" => [
        {
          type: :problem_report,
          path: "/vat-rates",
          created_at: DateTime.parse("2013-03-01"),
          what_doing: "looking at 3rd paragraph",
          what_wrong: "typo in 2rd word",
          referrer: "https://www.gov.uk/",
        },
        {
          type: :problem_report,
          path: "/vat-rates",
          created_at: DateTime.parse("2013-02-01"),
          what_doing: "looking at rates",
          what_wrong: "standard rate is wrong",
          referrer: "https://www.gov.uk/pay-vat",
        },
      ]
    }.to_json

    stub_get_anonymous_feedback(
      {
        starting_with_path: "/vat-rates",
      },
      response_body: data
    )

    feedback_reports = [
      {
        "Date" => "1 March 2013",
        "Feedback" => "action: looking at 3rd paragraph problem: typo in 2rd word",
        "URL" => "/vat-rates",
        "Referrer" => "/"
      }, {
        "Date" => "1 February 2013",
        "Feedback" => "action: looking at rates problem: standard rate is wrong",
        "URL" => "/vat-rates",
        "Referrer" => "/pay-vat"
      }
    ]

    explore_anonymous_feedback_with(url: "www.gov.uk/vat-rates")
    expect(feedex_results).to eq(feedback_reports)
  end

  scenario "no feedback found" do
    stub_get_anonymous_feedback(
      {
        starting_with_path: "/non-existent-path",
      },
      response_body: {
        "results" => []
      }.to_json
    )

    explore_anonymous_feedback_with(url: "https://www.gov.uk/non-existent-path")

    expect(page).to have_content("There is no feedback for this path.")
  end
end
