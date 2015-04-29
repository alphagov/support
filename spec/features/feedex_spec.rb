require 'rails_helper'

feature "Exploring anonymous feedback" do
  background do
    login_as create(:user)
  end

  scenario "exploring feedback by URL" do
    create(:problem_report,
      path: "/tax-disc",
      created_at: DateTime.parse("2013-01-01"),
      what_doing: "logging in",
      what_wrong: "error",
      referrer: "https://www.gov.uk",
    )

    create(:problem_report,
      path: "/vat-rates",
      created_at: DateTime.parse("2013-02-01"),
      what_doing: "looking at rates",
      what_wrong: "standard rate is wrong",
      referrer: "https://www.gov.uk/pay-vat",
    )

    create(:problem_report,
      path: "/vat-rates",
      created_at: DateTime.parse("2013-03-01"),
      what_doing: "looking at 3rd paragraph",
      what_wrong: "typo in 2rd word",
      referrer: "https://www.gov.uk",
    )

    feedback_reports = [
      {
        "Date" => "1 March 2013",
        "Feedback" => "action: looking at 3rd paragraph problem: typo in 2rd word",
        "URL" => "/vat-rates",
        "Referrer" => "https://www.gov.uk"
      }, {
        "Date" => "1 February 2013",
        "Feedback" => "action: looking at rates problem: standard rate is wrong",
        "URL" => "/vat-rates",
        "Referrer" => "https://www.gov.uk/pay-vat"
      }
    ]

    explore_anonymous_feedback_with(url: "https://www.gov.uk/vat-rates")
    expect(feedex_results).to eq(feedback_reports)

    explore_anonymous_feedback_with(url: "http:/www.gov.uk/vat-rates")
    expect(feedex_results).to eq(feedback_reports)

    explore_anonymous_feedback_with(url: "https//www.gov.uk/vat-rates")
    expect(feedex_results).to eq(feedback_reports)

    explore_anonymous_feedback_with(url: "www.gov.uk/vat-rates")
    expect(feedex_results).to eq(feedback_reports)

    explore_anonymous_feedback_with(url: "gov.uk/vat-rates")
    expect(feedex_results).to eq(feedback_reports)

    explore_anonymous_feedback_with(url: "/vat-rates")
    expect(feedex_results).to eq(feedback_reports)

    explore_anonymous_feedback_with(url: "vat-rates")
    expect(feedex_results).to eq(feedback_reports)
  end

  scenario "no feedback found" do
    explore_anonymous_feedback_with(url: "https://www.gov.uk/non-existent-path")

    expect(page).to have_content("There is no feedback for this path.")
  end
end
