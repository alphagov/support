require 'rails_helper'

feature "Analytics requests" do
  # In order to measure how well my content is meeting user need
  # As a government content producer
  # I want a means to request analytics data from GDS

  let(:user) { create(:user, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "successful request" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Request for analytics",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => [ "govt_form", "analytics" ],
      "comment" => { "body" =>
"[Reporting period]
From Start Q4 2012 to End 2012

[Requested pages/sections]
https://gov.uk/X

[Justification for needing report]
To measure campaign success

[More detailed analysis needed?]
I also need KPI Y

[Reporting frequency]
One-off

[Report format]
PDF"})

    user_makes_an_analytics_request(
      from: "Start Q4 2012",
      to: "End 2012",
      which_part_of_govuk: "https://gov.uk/X",
      justification: "To measure campaign success",
      more_detailed_analysis: "I also need KPI Y",
      frequency: "One-off",
      format: "PDF",
    )

    expect(request).to have_been_made
  end

  private
  def user_makes_an_analytics_request(details)
    visit '/'

    click_on "Analytics access, reports and help"

    expect(page).to have_content("Request access to Google Analytics or help with analytics or reports")

    fill_in "From", :with => details[:from]
    fill_in "To", :with => details[:to]

    fill_in "Which page(s) or section(s) on GOV.UK do you want data for? (Please provide URLs and, if possible or relevant, Need IDs)",
      with: details[:which_part_of_govuk]

    fill_in "How will you use the report and what decisions will it help you make?",
      with: details[:justification]

    fill_in "Beyond the basic report, what other information are you interested in?",
      with: details[:more_detailed_analysis]

    within "#frequency" do
      choose details[:frequency]
    end

    within "#format" do
      choose details[:format]
    end

    user_submits_the_request_successfully
  end
end
