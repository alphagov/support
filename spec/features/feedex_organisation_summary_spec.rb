require "rails_helper"
require "gds_api/test_helpers/support_api"

feature "Summary of Organisation feedback" do
  include GdsApi::TestHelpers::SupportApi
  background do
    login_as create(:user)
  end

  before do
    stub_support_api_document_type_list
    stub_summary_sorted_by("last_7_days")
    explore_anonymous_feedback_by_organisation("Cabinet Office")
  end

  scenario "defaults to sorting feedback by last 7 days" do
    expect(page).to have_content("Feedback for Cabinet Office")
    expect(organisation_summary_results).to eq(organisation_summary)
    expect(page).to have_selector("th.sorted-column", text: "7 days")
  end

  scenario "organisation feedback table can be sorted by path, 7, 30 and 90 days" do
    {
      path: "Page",
      last_7_days: "7 days",
      last_30_days: "30 days",
      last_90_days: "90 days",
    }.each do |param, name|
      stub_summary_sorted_by(param.to_s)
      within ".table-sortable thead" do
        click_on name
      end
      expect(organisation_summary_results).to eq(organisation_summary)
      expect(page).to have_selector("th.sorted-column", text: name)
      expect(page).to have_no_selector("th a", text: name)
    end
  end

  def stub_summary_sorted_by(ordering)
    stub_support_api_anonymous_feedback_organisation_summary(
      "cabinet-office",
      ordering,
      "title" => "Cabinet Office",
      "anonymous_feedback_counts" => [
        { path: "/done-well", last_7_days: 5, last_30_days: 10, last_90_days: 20 },
        { path: "/not-bad-my-friend" },
        { path: "/fair-enough" },
      ],
    )
  end

  def organisation_summary
    [
      {
        "Page" => "/done-well",
        "7 days" => "5 items",
        "30 days" => "10 items",
        "90 days" => "20 items",
      },
      {
        "Page" => "/not-bad-my-friend",
        "7 days" => "0 items",
        "30 days" => "0 items",
        "90 days" => "0 items",
      },
      {
        "Page" => "/fair-enough",
        "7 days" => "0 items",
        "30 days" => "0 items",
        "90 days" => "0 items",
      },
    ]
  end
end
