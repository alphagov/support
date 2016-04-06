require 'rails_helper'
require 'gds_api/test_helpers/support_api'

feature "Exploring anonymous feedback" do
  include GdsApi::TestHelpers::SupportApi
  background do
    login_as create(:user)
  end

  scenario "exploring feedback by URL" do
    stub_anonymous_feedback_with_default_date_range(
      { path_prefix: "/vat-rates" },
      {
        "current_page" => 1,
        "pages" => 1,
        "page_size" => 2,
        "results" => [
          {
            type: "problem-report",
            path: "/vat-rates",
            url: "http://www.dev.gov.uk/vat-rates",
            created_at: 10.days.ago,
            what_doing: "looking at 3rd paragraph",
            what_wrong: "typo in 2rd word",
            referrer: "https://www.gov.uk/",
          },
          {
            type: "problem-report",
            path: "/vat-rates",
            url: "http://www.dev.gov.uk/vat-rates",
            created_at: 20.days.ago,
            what_doing: "looking at rates",
            what_wrong: "standard rate is wrong",
            referrer: "https://www.gov.uk/pay-vat",
          },
        ]
      }
    )

    feedback_reports = [
      {
        "Date" => 10.days.ago.strftime('%e %b %Y'),
        "Feedback" => "Action: Looking at 3rd paragraph Problem: Typo in 2rd word",
        "URL" => "/vat-rates",
        "Referrer" => "/"
      }, {
        "Date" => 20.days.ago.strftime('%e %b %Y'),
        "Feedback" => "Action: Looking at rates Problem: Standard rate is wrong",
        "URL" => "/vat-rates",
        "Referrer" => "/pay-vat"
      }
    ]

    explore_anonymous_feedback_with(url: "www.gov.uk/vat-rates")
    expect(feedex_results).to eq(feedback_reports)
  end

  scenario "no feedback found" do
    stub_anonymous_feedback_with_default_date_range(
      { path_prefix: "/non-existent-path" },
      { "results" => [], "pages" => 0, "current_page" => 1 }
    )

    explore_anonymous_feedback_with(url: "https://www.gov.uk/non-existent-path")

    expect(page).to have_content("There’s no feedback for this URL.")
  end

  scenario "exploring feedback by organisation" do
    stub_anonymous_feedback_organisation_summary('cabinet-office', 'last_7_days', {
      "title" => "Cabinet Office",
      "anonymous_feedback_counts" => [
        { path: '/done-well', last_7_days: 5, last_30_days: 10, last_90_days: 20 },
        { path: '/not-bad-my-friend' },
        { path: '/fair-enough' },
      ],
    })

    organisation_summary = [
      {
        "Page" => "/done-well",
        "7 days" => "5 items",
        "30 days" => "10 items",
        "90 days" => "20 items",
      }, {
        "Page" => "/not-bad-my-friend",
        "7 days" => "0 items",
        "30 days" => "0 items",
        "90 days" => "0 items",
      }, {
        "Page" => "/fair-enough",
        "7 days" => "0 items",
        "30 days" => "0 items",
        "90 days" => "0 items",
      }
    ]

    explore_anonymous_feedback_with(organisation: "Cabinet Office")
    expect(page).to have_content("Feedback for Cabinet Office")
    expect(organisation_summary_results).to eq(organisation_summary)
  end
end
