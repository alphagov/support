require 'rails_helper'

feature "Campaign requests" do
  # In order to run a successful campaign
  # As a government employee
  # I want to request GDS support for a campaign

  let(:user) { create(:campaign_requester, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "successful request" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Campaign",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => [ "govt_form", "campaign" ],
      "comment" => { "body" =>
"[Campaign title]
Workplace pensions

[ERG reference number]
123456

[Start date]
01-01-2020

[Description]
Pensions

[Affiliated group or company]
AXA

[URL with more information]
https://www.gov.uk

[Additional comments]
Some comment"})

    user_makes_a_campaign_request(
      campaign_title: "Workplace pensions",
      erg_reference_number: "123456",
      start_date: "01-01-2020",
      description: "Pensions",
      affiliated_group: "AXA",
      info_url: "https://www.gov.uk",
      additional_comments: "Some comment",
    )

    expect(request).to have_been_made
  end

  private
  def user_makes_a_campaign_request(details)
    visit '/'

    click_on "Campaign"

    expect(page).to have_content("Request GDS support for a campaign")

    fill_in "Campaign title", with: details[:campaign_title]
    fill_in "ERG reference number", with: details[:erg_reference_number]
    fill_in "Start date", with: details[:start_date]
    fill_in "Campaign description", with: details[:description]
    fill_in "Group or company affiliated with this campaign", with: details[:affiliated_group]
    fill_in "URL with more information", with: details[:info_url]
    fill_in "Additional comments", with: details[:additional_comments]

    user_submits_the_request_successfully
  end
end
