require "rails_helper"

feature "Campaign requests" do
  # In order to run a successful campaign
  # As a government employee
  # I want to request GDS support for a campaign

  let(:user) { create(:campaign_requester, name: "John Smith", email: "john.smith@agency.gov.uk") }
  let(:next_year) { Time.zone.now.year.succ }

  background do
    login_as user
  end

  scenario "successful request" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Campaign",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => %w[govt_form campaign],
      "description" =>
"[Name of the Head of Digital Communications who signed off the campaign website application]
John Smith

[Start date of campaign site]
01-01-#{next_year}

[Proposed end date of campaign site]
01-02-#{next_year}

[Site build to commence on]
31-12-2019

[Contact email/s for website performance review every 6 months]
john.smith@example.com

[Which of the current Government Communications Plan priority themes does this campaign website support and how?]
Example government theme

[Campaign description]
Pensions

[Call to action]
Join us in this campaign for pensions

[Proposed URL (in the form of xxxxx.campaign.gov.uk)]
newcampaign.campaign.gov.uk

[Site title]
New campaign

[Site tagline]
A new one about a new thing

[Site metadescription (appears in search results)]
pensions, campaign, newcampaign

[Site build budget / costs (and overall campaign cost, if applicable)]
£1200 and tuppence

[HMG code: from approved AMC technical cases. Format: HMGXX-XXX (If not applicable enter n/a)]
HMGXX-XXX

[Strategic Planning Code: from strategic planning phase. Format: CSBXX-XXX (If not applicable enter n/a)]
CSBXX-XXX

[Contact details for Google Analytics leads (Gmail accounts only)]
ga.contact@example.com

[Additional comments]
Some comment

[I/We have read the GCS guidance on campaign websites and accept the requirements for a Campaign Platform website]
Yes

[I/We have followed the GCS guidance for OASIS planning and are using the mandatory GCS OASIS template]
Yes

[I/We will take full responsibility for all aspects of managing and resourcing this campaign site from Discovery stage to site build/content development, to site closure]
Yes

[I/We will ensure the site meets all government web accessibility standards, and that it will be tested and the Accessibility Statement completed before final review]
Yes

[I/We agree to take responsibility to maintain and up-date the Cookie Notice and Privacy Notice as necessary, with our Data Protection Officer]
Yes",
    )

    user_makes_a_campaign_request(
      has_read_guidance: true,
      has_read_oasis_guidance: true,
      full_responsibility_confirmation: true,
      accessibility_confirmation: true,
      cookie_and_privacy_notice_confirmation: true,
      signed_campaign: "John Smith",
      start_date: "01-01-#{next_year}",
      end_date: "01-02-#{next_year}",
      development_start_date: "31-12-2019",
      performance_review_contact_email: "john.smith@example.com",
      government_theme: "Example government theme",
      description: "Pensions",
      call_to_action: "Join us in this campaign for pensions",
      proposed_url: "newcampaign.campaign.gov.uk",
      site_title: "New campaign",
      site_tagline: "A new one about a new thing",
      site_metadescription: "pensions, campaign, newcampaign",
      cost_of_campaign: "£1200 and tuppence",
      hmg_code: "HMGXX-XXX",
      strategic_planning_code: "CSBXX-XXX",
      ga_contact_email: "ga.contact@example.com",
      additional_comments: "Some comment",
    )

    expect(request).to have_been_made
  end

private

  def user_makes_a_campaign_request(details)
    visit "/"

    click_on "Request a new campaign"

    expect(page).to have_content("Request GDS support for a new campaign")

    check "I/We have read the GCS guidance on campaign websites and accept the requirements for a Campaign Platform website" if details[:has_read_guidance]
    check "I/We have followed the GCS guidance for OASIS planning and are using the mandatory GCS OASIS template" if details[:has_read_oasis_guidance]
    check "I/We will take full responsibility for all aspects of managing and resourcing this campaign site from Discovery stage to site build/content development, to site closure. The site must be regularly reviewed to ensure a high standard of work. GCS reserves the right to close the site if standard of the site drops below expectations." if details[:full_responsibility_confirmation]
    check "I/We will ensure the site meets all government web accessibility standards, and that it will be tested and the Accessibility Statement completed before final review (if your team doesn't have expertise in accessible content design then appropriate training must be undertaken before the site build.)" if details[:accessibility_confirmation]
    check "I/We agree to take responsibility to maintain and up-date the Cookie Notice and Privacy Notice as necessary, with our Data Protection Officer (NB : GDS will add a basic \"boilerplate\", however departments will need to identify if additions are needed)." if details[:cookie_and_privacy_notice_confirmation]

    fill_in "Name of the Head of Digital Communications who signed off the campaign website application*", with: details[:signed_campaign]
    fill_in "Start date of campaign site*", with: details[:start_date]
    fill_in "Proposed end date of campaign site*", with: details[:end_date]
    fill_in "Site build to commence on", with: details[:development_start_date]
    fill_in "Contact email/s for website performance review every 6 months*", with: details[:performance_review_contact_email]
    fill_in "Which of the current Government Communications Plan priority themes does this campaign website support and how?*", with: details[:government_theme]
    fill_in "Campaign description*", with: details[:description]
    fill_in "Call to action*", with: details[:call_to_action]
    fill_in "Proposed URL (in the form of xxxxx.campaign.gov.uk)*", with: details[:proposed_url]
    fill_in "Site title*", with: details[:site_title]
    fill_in "Site tagline*", with: details[:site_tagline]
    fill_in "Site metadescription (appears in search results)*", with: details[:site_metadescription]
    fill_in "Site build budget / costs (and overall campaign cost, if applicable)*", with: details[:cost_of_campaign]
    fill_in "HMG code: from approved AMC technical cases. Format: HMGXX-XXX (If not applicable enter n/a)", with: details[:hmg_code]
    fill_in "Strategic Planning Code: from strategic planning phase. Format: CSBXX-XXX (If not applicable enter n/a)", with: details[:strategic_planning_code]
    fill_in "Cabinet Office/No10 only : Contact details for Google Analytics leads (Gmail accounts only)", with: details[:ga_contact_email]
    fill_in "Additional comments", with: details[:additional_comments]

    user_submits_the_request_successfully
  end
end
