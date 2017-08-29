require 'rails_helper'
require 'gds_api/test_helpers/support_api'

feature "Exploring anonymous feedback" do
  include GdsApi::TestHelpers::SupportApi
  background do
    login_as create(:user)
  end

  scenario "exploring feedback by URL" do
    stub_support_api_anonymous_feedback(
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
    stub_support_api_anonymous_feedback(
      { path_prefix: "/non-existent-path" },
      { "results" => [], "pages" => 0, "current_page" => 1 }
    )

    explore_anonymous_feedback_with(url: "https://www.gov.uk/non-existent-path")

    expect(page).to have_content("There’s no feedback for this URL.")
  end

  scenario "exploring feedback by organisation" do
    stub_support_api_anonymous_feedback_organisation_summary(
      'cabinet-office',
      'last_7_days',
      {
        "title" => "Cabinet Office",
        "slug" => 'cabinet-office',
        "anonymous_feedback_counts" => [
          { path: '/done-well', last_7_days: 5, last_30_days: 10, last_90_days: 20 },
          { path: '/not-bad-my-friend' },
          { path: '/fair-enough' },
        ],
      }
    )

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

  scenario "exploring feedback by organisation and URL" do
    stub_support_api_organisation('cabinet-office')
    org_summary_request = stub_support_api_anonymous_feedback_organisation_summary('cabinet-office', 'last_7_days', {
      "title" => "Cabinet Office",
      "slug" => 'cabinet-office',
      "anonymous_feedback_counts" => [
        { path: '/vat-rates', last_7_days: 5, last_30_days: 10, last_90_days: 20 },
        { path: '/guidance/doing-fun-things' },
        { path: '/guidance/not-doing-bad-things' },
      ],
    })

    org_feedback_request = stub_support_api_anonymous_feedback(
      { organisation_slug: "cabinet-office" },
      {
        "current_page" => 1,
        "pages" => 1,
        "page_size" => 3,
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
            path: "/guidance/doing-fun-things",
            url: "http://www.dev.gov.uk/guidance/doing-fun-things",
            created_at: DateTime.parse("2013-02-01"),
            what_doing: "finding out about fun",
            what_wrong: "no mention of petting a dog",
            referrer: "https://www.gov.uk/having-fun",
          },
          {
            type: "problem-report",
            path: "/guidance/doing-bad-things",
            url: "http://www.dev.gov.uk/guidance/not-doing-bad-things",
            created_at: DateTime.parse("2013-02-01"),
            what_doing: "looking at what you consider bad",
            what_wrong: "so many typos, whoever wrote this must have been angry",
            referrer: "https://www.gov.uk/having-fun",
          },
        ]
      }
    )

    org_and_path_feedback_request = stub_support_api_anonymous_feedback(
      { organisation_slug: "cabinet-office", path_prefix: '/guidance' },
      {
        "current_page" => 1,
        "pages" => 1,
        "page_size" => 2,
        "results" => [
          {
            type: "problem-report",
            path: "/guidance/doing-fun-things",
            url: "http://www.dev.gov.uk/guidance/doing-fun-things",
            created_at: DateTime.parse("2013-02-01"),
            what_doing: "finding out about fun",
            what_wrong: "no mention of petting a dog",
            referrer: "https://www.gov.uk/having-fun",
          },
          {
            type: "problem-report",
            path: "/guidance/doing-bad-things",
            url: "http://www.dev.gov.uk/guidance/doing-bad-things",
            created_at: DateTime.parse("2013-02-01"),
            what_doing: "looking at what you consider bad",
            what_wrong: "so many typos, whoever wrote this must have been angry",
            referrer: "https://www.gov.uk/having-fun",
          },
        ]
      }
    )

    path_feedback_request = stub_support_api_anonymous_feedback(
      { path_prefix: '/guidance' },
      {
        "current_page" => 1,
        "pages" => 1,
        "page_size" => 2,
        "results" => [
          {
            type: "problem-report",
            path: "/guidance/doing-fun-things",
            url: "http://www.dev.gov.uk/guidance/doing-fun-things",
            created_at: DateTime.parse("2013-02-01"),
            what_doing: "finding out about fun",
            what_wrong: "no mention of petting a dog",
            referrer: "https://www.gov.uk/having-fun",
          },
          {
            type: "problem-report",
            path: "/guidance/doing-bad-things",
            url: "http://www.dev.gov.uk/guidance/doing-bad-things",
            created_at: DateTime.parse("2013-02-01"),
            what_doing: "looking at what you consider bad",
            what_wrong: "so many typos, whoever wrote this must have been angry",
            referrer: "https://www.gov.uk/having-fun",
          },
          {
            type: "problem-report",
            path: "/guidance/wearing-a-hat",
            url: "http://www.dev.gov.uk/guidance/wearing-a-hat",
            created_at: DateTime.parse("2013-02-01"),
            what_doing: "want to know about balaclavas",
            what_wrong: "I know they're not really a hat, but would it hurt to mention them",
            referrer: "https://www.gov.uk/hats",
          },
        ]
      }
    )


    explore_anonymous_feedback_with(organisation: "Cabinet Office")

    expect(org_summary_request).to have_been_requested
    expect(org_feedback_request).not_to have_been_requested
    expect(org_and_path_feedback_request).not_to have_been_requested
    expect(path_feedback_request).not_to have_been_requested

    click_on 'All feedback for Cabinet Office'

    expect(org_feedback_request).to have_been_requested
    expect(org_and_path_feedback_request).not_to have_been_requested
    expect(path_feedback_request).not_to have_been_requested

    expect(page).to have_title("Feedback for “Cabinet Office”")
    expect(page).to have_select("Organisation", selected: 'Cabinet Office (CO)')

    # NOTE: this doesn't work as the value of the input is nil and that doesn't
    # match "" (capybara to_s's the with so we can't pass in nil either
    # expect(page).to have_field("URL", with: "")
    empty_url_field = page.find_field("URL")
    expect(empty_url_field).not_to be_nil
    expect(empty_url_field.value).to be_blank

    fill_in 'URL', with: '/guidance'
    click_on 'Filter'

    expect(org_and_path_feedback_request).to have_been_requested
    expect(path_feedback_request).not_to have_been_requested

    expect(page).to have_title('Feedback for “Cabinet Office on /guidance”')
    expect(page).to have_select("Organisation", selected: 'Cabinet Office (CO)')
    expect(page).to have_field("URL", with: '/guidance')

    click_on "Remove organisation filter"

    expect(page).to have_title('Feedback for “/guidance”')
    expect(page).to have_select("Organisation", selected: [])
    expect(page).to have_field("URL", with: '/guidance')

    expect(path_feedback_request).to have_been_requested
  end
end
