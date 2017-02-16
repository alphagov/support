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

[Other department(s) or agencies running the campaign (if any)]
Department 1

[Head of Digital who signed off the campaign]
John Smith

[Start date]
01-01-2020

[Campaign end date / review date (within 6 months of launch)]
01-02-2020

[Campaign description]
Pensions

[Call to action]
Join us in this campaign for pensions

[How will you measure success?]
Surveys

[Proposed URL (in the form of xxxxx.campaign.gov.uk)]
newcampaign.campaign.gov.uk

[Site metadescription (appears in search results)]
pensions, campaign, newcampaign

[Cost of campaign]
1200

[Additional comments]
Some comment"})

    user_makes_a_campaign_request(
      title: "Workplace pensions",
      other_dept_or_agency: "Department 1",
      signed_campaign: "John Smith",
      start_date: "01-01-2020",
      end_date: "01-02-2020",
      description: "Pensions",
      call_to_action: "Join us in this campaign for pensions",
      success_measure: "Surveys",
      proposed_url: "newcampaign.campaign.gov.uk",
      site_metadescription: "pensions, campaign, newcampaign",
      cost_of_campaign: "1200",
      additional_comments: "Some comment"
    )

    expect(request).to have_been_made
  end

  private
  def user_makes_a_campaign_request(details)
    visit '/'

    click_on "Campaign requests and support"

    expect(page).to have_content("Request GDS support for a campaign")

    fill_in "Campaign title", with: details[:title]
    fill_in "Other department(s) or agencies running the campaign (if any)", with: details[:other_dept_or_agency]
    fill_in "Head of Digital who signed off the campaign", with: details[:signed_campaign]
    fill_in "Start date", with: details[:start_date]
    fill_in "Campaign end date / review date (within 6 months of launch)", with: details[:end_date]
    fill_in "Campaign description", with: details[:description]
    fill_in "Call to action", with: details[:call_to_action]
    fill_in "How will you measure success?", with: details[:success_measure]
    fill_in "Proposed URL (in the form of xxxxx.campaign.gov.uk)", with: details[:proposed_url]
    fill_in "Site metadescription (appears in search results)", with: details[:site_metadescription]
    fill_in "Cost of campaign", with: details[:cost_of_campaign]
    fill_in "Additional comments", with: details[:additional_comments]

    user_submits_the_request_successfully
  end
end
