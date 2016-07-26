require 'rails_helper'

feature "Content change requests" do
  # In order to update or correct the information on GOV.UK
  # As a government employee
  # I want to inform GDS about what needs changing and why

  let(:user) { create(:content_requester, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "successful mainstream content change request " do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Update X - Content change request",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => [ "govt_form", "content_amend" ],
      "comment" => { "body" =>
"[Needed by date]
31-12-2020

[Not before date]
01-12-2020

[Reason for time constraint]
New law

[URL of content to be changed]
http://gov.uk/X

[Related URLs]
XXXXX

[Details of what should be added, amended or removed]
Out of date XX YY"})

    user_makes_a_content_change_request(
      title: "Update X",
      details_of_change: "Out of date XX YY",
      url: "http://gov.uk/X",
      related_urls: "XXXXX",
      needed_by_date: "31-12-2020",
      not_before_date: "01-12-2020",
      reason: "New law",
    )

    expect(request).to have_been_made
  end

  scenario "successful 'Depts and Policy' content change request " do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Content change request",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => %w{govt_form content_amend})

    user_makes_a_content_change_request(
      context: "Departments and policy",
      details_of_change: "Out of date XX YY",
    )

    expect(request).to have_been_made
  end

  private
  def user_makes_a_content_change_request(details)
    visit '/'

    click_on "Content changes and new content requests"

    expect(page).to have_content("Request changes to GOV.UK content managed by GDS content designers")

    fill_in "Title of request", with: details[:title] unless details[:title].nil?
    fill_in "Details of the requested change", with: details[:details_of_change]
    fill_in "URL", with: details[:url]
    fill_in "Does this affect any other URLs? (please specify one per line)", with: details[:related_urls]

    user_fills_out_time_constraints(details)

    user_submits_the_request_successfully
  end
end
