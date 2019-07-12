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
      "tags" => %w[govt_form campaign],
      "comment" => {
        "body" =>
"[Are you applying for the campaign platform or a bespoke microsite?]
Campaign platform

[Name of the head of digital who signed off the campaign website application]
John Smith

[Start date of campaign site]
01-01-2020

[Proposed end date of campaign site]
01-02-2020

[Site build to commence on]
02-01-2020

[Contact email/s for website performance review every 6 months]
john.smith@example.com

[Which of the current Government Communications Plan priority themes does this campaign website support and how?]
Example government theme

[Campaign description]
Pensions

[Call to action]
Join us in this campaign for pensions

[Proposed URL (in the form of xxxxx.campaign.gov.uk or xxxxx.gov.uk)]
newcampaign.campaign.gov.uk

[The short campaign title, approx 1 - 3 words]
New campaign

[Explain what this site is about, approx 7 - 8 words]
A new one about a new thing

[Approx 20-30 words. A more detailed description or call to action]
pensions, campaign, newcampaign

[Site build budget / costs (and overall campaign cost, if applicable)]
1200

[Contact details for Google Analytics leads (Gmail accounts only)]
ga.contact@example.com

[Additional comments]
Some comment"
      }
    )

    user_makes_a_campaign_request(
      type_of_site: "Campaign platform",
      has_read_guidance: true,
      has_read_oasis_guidance: true,
      signed_campaign: "John Smith",
      start_date: "01-01-2020",
      end_date: "01-02-2020",
      development_start_date: "02-01-2020",
      performance_review_contact_email: "john.smith@example.com",
      government_theme: "Example government theme",
      description: "Pensions",
      call_to_action: "Join us in this campaign for pensions",
      proposed_url: "newcampaign.campaign.gov.uk",
      site_title: 'New campaign',
      site_tagline: 'A new one about a new thing',
      site_metadescription: "pensions, campaign, newcampaign",
      cost_of_campaign: "1200",
      ga_contact_email: "ga.contact@example.com",
      additional_comments: "Some comment"
      )

    expect(request).to have_been_made
  end

private

  def user_makes_a_campaign_request(details)
    visit '/'

    click_on "Request a new campaign"

    expect(page).to have_content("Request GDS support for a new campaign")

    choose details[:type_of_site]
    check "Have you read the the GCS guidance on campaign websites and accept the requirements for a Campaign Platform website?" if details[:has_read_guidance]
    check "Have you followed the GCS guidance for OASIS planning and are using the mandatory GCS OASIS template?" if details[:has_read_oasis_guidance]
    fill_in "Name of the head of digital who signed off the campaign website application*", with: details[:signed_campaign]
    fill_in "Start date of campaign site*", with: details[:start_date]
    fill_in "Proposed end date of campaign site*", with: details[:end_date]
    fill_in "Site build to commence on", with: details[:development_start_date]
    fill_in "Contact email/s for website performance review every 6 months*", with: details[:performance_review_contact_email]
    fill_in "Which of the current Government Communications Plan priority themes does this campaign website support and how?*", with: details[:government_theme]
    fill_in "Campaign description*", with: details[:description]
    fill_in "Call to action*", with: details[:call_to_action]
    fill_in "Proposed URL (in the form of xxxxx.campaign.gov.uk or xxxxx.gov.uk)*", with: details[:proposed_url]
    fill_in "The short campaign title, approx 1 - 3 words, eg \"Action Counters Terrorism\"*", with: details[:site_title]
    fill_in "Explain what this site is about, approx 7 - 8 words, eg \"Report terrorist or extremist content online\"*", with: details[:site_tagline]
    fill_in 'Approx 20-30 words. A more detailed description or call to action, e.g. "Report terrorism activity online. If you\'ve seen or heard something that is suspicious and may be terrorism related - report it anonymously."*', with: details[:site_metadescription]
    fill_in "Site build budget / costs (and overall campaign cost, if applicable)*", with: details[:cost_of_campaign]
    fill_in "Contact details for Google Analytics leads (Gmail accounts only)*", with: details[:ga_contact_email]
    fill_in "Additional comments", with: details[:additional_comments]

    user_submits_the_request_successfully
  end
end
