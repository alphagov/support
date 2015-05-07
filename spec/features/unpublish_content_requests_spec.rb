require 'rails_helper'

feature "Unpublish content requests" do
  # In order to reduce user confusion and damage to government reputation
  # As a government employee
  # I want to ask the Departments and policy team to unpublish content

  let(:user) { create(:user, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "request to unpublish in case of publishing error" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Published in error - Unpublish content request",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => [ "govt_form", "unpublish_content", "inside_government", "published_in_error" ],
      "comment" => { "body" =>
"[URL of content to be unpublished]
https://www.gov.uk/X

[Reason]
Published in error

[Further explanation]
Typo in slug name"})

    user_makes_a_request_to_unpublish_content(
      url: "https://www.gov.uk/X",
      reason: "Published in error",
      further_explanation: "Typo in slug name",
    )

    expect(request).to have_been_made
  end

  scenario "request to unpublish when page is a dupe" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Duplicate of another page - Unpublish content request",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => [ "govt_form", "unpublish_content", "inside_government", "duplicate_publication" ],
      "comment" => { "body" =>
"[URL of content to be unpublished]
https://www.gov.uk/X

[Reason]
Duplicate of another page

[Further explanation]
Some reason

[Redirect URL]
https://www.gov.uk/Y

[Automatic redirect?]
true"})

    user_makes_a_request_to_unpublish_content(
      url: "https://www.gov.uk/X",
      reason: "Duplicate of another page",
      further_explanation: "Some reason",
      redirect_url: "https://www.gov.uk/Y",
      automatic_redirect: true
    )

    expect(request).to have_been_made
  end

  private
  def user_makes_a_request_to_unpublish_content(details)
    visit '/'

    click_on "Unpublish content"

    expect(page).to have_content("Request to unpublish content")

    fill_in "Please give the Whitehall URL of the page you wish to have unpublished (you can specify more than one URL, as long as it's clear where each URL should be redirected)", with: details[:url]

    within "#unpublish-reason" do
      choose details[:reason]
    end

    fill_in "Redirects will be automatic unless you give a reason:", with: details[:further_explanation]

    fill_in "Redirect URL", with: details[:redirect_url] if details[:redirect_url]

    check "Redirect to URL automatically?" if details[:automatic_redirect]

    user_submits_the_request_successfully
  end
end
