require 'rails_helper'

feature "Remove user requests" do
  # In order to reduce the risk of a disgruntled ex-employee doing something damaging
  # As a government employee responsible for a user of GDS tools
  # I want to request to revoke the user's access (usually after they've left the org)

  let(:user) { create(:user_manager, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "successful request" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Remove user",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => %w[govt_form remove_user],
      "comment" => {
        "body" =>
"[Not before date]
31-12-2020

[User name]
Bob

[User email]
bob@someagency.gov.uk

[Reason for removal]
User has left the organisation"
      }
    )

    user_requests_removal_of_another_user(
      user_name: "Bob",
      user_email: "bob@someagency.gov.uk",
      reason_for_removal: "User has left the organisation",
      not_before_date: "31-12-2020"
    )

    expect(request).to have_been_made
  end

private

  def user_requests_removal_of_another_user(details)
    visit '/'

    click_on "Remove user"

    expect(page).to have_content("Request to remove user access")

    within("#user_details") do
      fill_in "Name", with: details[:user_name]
      fill_in "Email", with: details[:user_email]
      fill_in "Reason for removal", with: details[:reason_for_removal]
    end

    fill_in "MUST NOT be removed BEFORE", with: details[:not_before_date]

    user_submits_the_request_successfully
  end
end
