require 'rails_helper'
require 'gds_api/test_helpers/support_api'

feature "Exploring anonymous feedback" do
  include GdsApi::TestHelpers::SupportApi
  background do
    login_as create(:user)
  end

  scenario "exploring feedback by URL" do
    stub_anonymous_feedback(
      { path_prefix: "/vat-rates", from: nil, to: nil },
      {
        "current_page" => 1,
        "pages" => 1,
        "page_size" => 2,
        "results" => [
          {
            type: "problem-report",
            path: "/vat-rates",
            url: "http://www.dev.gov.uk/vat-rates",
            created_at: DateTime.parse("2013-03-01"),
            what_doing: "looking at 3rd paragraph",
            what_wrong: "typo in 2rd word",
            referrer: "https://www.gov.uk/",
          },
          {
            type: "problem-report",
            path: "/vat-rates",
            url: "http://www.dev.gov.uk/vat-rates",
            created_at: DateTime.parse("2013-02-01"),
            what_doing: "looking at rates",
            what_wrong: "standard rate is wrong",
            referrer: "https://www.gov.uk/pay-vat",
          },
        ]
      }
    )

    feedback_reports = [
      {
        "Date" => "1 Mar 2013",
        "Feedback" => "Action: Looking at 3rd paragraph Problem: Typo in 2rd word",
        "URL" => "/vat-rates",
        "Referrer" => "/"
      }, {
        "Date" => "1 Feb 2013",
        "Feedback" => "Action: Looking at rates Problem: Standard rate is wrong",
        "URL" => "/vat-rates",
        "Referrer" => "/pay-vat"
      }
    ]

    explore_anonymous_feedback_with(url: "www.gov.uk/vat-rates")
    expect(feedex_results).to eq(feedback_reports)
  end

  scenario "no feedback found" do
    stub_anonymous_feedback(
      { path_prefix: "/non-existent-path", from: nil, to: nil },
      { "results" => [], "pages" => 0, "current_page" => 1 }
    )

    explore_anonymous_feedback_with(url: "https://www.gov.uk/non-existent-path")

    expect(page).to have_content("There is no feedback for this path.")
  end
end
