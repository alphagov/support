require 'rails_helper'
require 'gds_api/test_helpers/support_api'

feature "User satisfaction survey submissions" do
  include GdsApi::TestHelpers::SupportApi
  # In order to fix and improve my service (that's linked on GOV.UK)
  # As a service manager
  # I want to record and view bugs, gripes and improvement suggestions submitted by the service users

  background do
    login_as create(:user)
    Timecop.travel Date.parse("2013-02-28")
  end

  scenario "submission with comment" do
    stub_support_api_anonymous_feedback(
      { path_prefix: "/done/find-court-tribunal" },
      "current_page" => 1,
      "pages" => 1,
      "page_size" => 1,
      "results" => [
        {
          type: "service-feedback",
          slug: "find-court-tribunal",
          path: "/done/find-court-tribunal",
          url: "http://www.dev.gov.uk/done/find-court-tribunal",
          service_satisfaction_rating: 3,
          details: "Make service less 'meh'",
          user_agent: "Safari",
          javascript_enabled: true,
          created_at: Time.now,
          updated_at: Time.now,
        }
      ]
    )

    explore_anonymous_feedback_with(url: "https://www.gov.uk/done/find-court-tribunal")

    expect(feedex_results).to eq([
      {
        "Date" => "28 Feb 2013",
        "Feedback" => "rating: 3 comment: Make service less 'meh'",
        "URL" => "/done/find-court-tribunal",
        "Referrer" => ""
      }
    ])
  end

  scenario "submission without a comment" do
    stub_support_api_anonymous_feedback(
      { path_prefix: "/done/some-service" },
      "current_page" => 1,
      "pages" => 1,
      "page_size" => 1,
      "results" => [
        {
          type: "service-feedback",
          slug: "some-service",
          path: "/done/some-service",
          url: "http://www.dev.gov.uk/done/some-service",
          service_satisfaction_rating: 3,
          details: nil,
          javascript_enabled: true,
          created_at: Time.now.to_s,
        },
      ],
    )

    explore_anonymous_feedback_with(url: "https://www.gov.uk/done/some-service")

    expect(feedex_results.first["Feedback"]).to eq("rating: 3")
  end
end
