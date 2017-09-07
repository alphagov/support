require 'rails_helper'

feature "Live Campaign requests" do
  # In order to run a successful live campaign
  # As a government employee
  # I want to request GDS support for a live campaign

  let(:user) { create(:campaign_requester, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "successful request" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Live Campaign",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => %w[govt_form live_campaign],
      "comment" => { "body" => "[Campaign Title]
Workplace pensions

[Campaign URL]
newcampaign.campaign.gov.uk

[Details of requested support]
Pensions

[Are there any time constraints for this request?]
This is a time constraint

[Reason for the above dates?]
This is a reason for choosing specific dates"})

    user_makes_a_live_campaign_request(
      title: "Workplace pensions",
      proposed_url: "newcampaign.campaign.gov.uk",
      description: "Pensions",
      time_constraints: "This is a time constraint",
      reason_for_dates: "This is a reason for choosing specific dates",
    )

    expect(request).to have_been_made
  end

  private

  def user_makes_a_live_campaign_request(details)
    visit '/'

    click_on "Support for live campaign"

    expect(page).to have_content("Request GDS support for a live campaign")

    fill_in "Campaign title", with: details[:title]
    fill_in "Campaign URL", with: details[:proposed_url]
    fill_in "Details of requested support", with: details[:description]
    fill_in "Are there any time constraints for this request?", with: details[:time_constraints]
    fill_in "Reason for the above dates?", with: details[:reason_for_dates]

    user_submits_the_request_successfully
  end
end
