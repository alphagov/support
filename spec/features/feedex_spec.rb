require 'rails_helper'

feature "Exploring anonymous feedback" do
  background do
    login_as create(:user)
  end

  scenario "exploring feedback by URL" do
    create(:problem_report,
      url: "https://www.gov.uk/tax-disc",
      created_at: DateTime.parse("2013-01-01"),
      what_doing: "logging in",
      what_wrong: "error",
      referrer: "https://www.gov.uk",
    )

    create(:problem_report,
      url: "https://www.gov.uk/vat-rates",
      created_at: DateTime.parse("2013-02-01"),
      what_doing: "looking at rates",
      what_wrong: "standard rate is wrong",
      referrer: "https://www.gov.uk/pay-vat",
    )

    create(:problem_report,
      url: "https://www.gov.uk/vat-rates",
      created_at: DateTime.parse("2013-03-01"),
      what_doing: "looking at 3rd paragraph",
      what_wrong: "typo in 2rd word",
      referrer: "https://www.gov.uk",
    )

    explore_anonymous_feedback_with(url: "https://www.gov.uk/vat-rates")

    expect(feedex_results).to eq([
      {
        "creation date" => "01.03.2013",
        "feedback" => "action: looking at 3rd paragraph problem: typo in 2rd word",
        "full path" => "/vat-rates",
        "user came from" => "https://www.gov.uk"
      }, {
        "creation date" => "01.02.2013",
        "feedback" => "action: looking at rates problem: standard rate is wrong",
        "full path" => "/vat-rates",
        "user came from" => "https://www.gov.uk/pay-vat"
      }
    ])
  end

  scenario "no feedback found" do
    explore_anonymous_feedback_with(url: "https://www.gov.uk/non-existent-path")

    expect(page).to have_content("There is no feedback for this path.")
  end
end
