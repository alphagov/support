require "rails_helper"

feature "Remove user requests" do
  # In order to reduce the risk of a disgruntled ex-employee doing something damaging
  # As a government employee responsible for a user of GDS tools
  # I want to request to revoke the user's access (usually after they've left the org)

  let(:user) { create(:user_manager, name: "John Smith", email: "john.smith@agency.gov.uk") }
  let(:next_year) { Time.zone.now.year.succ }

  background do
    login_as user
  end

  scenario "successful request" do
    request = expect_support_api_to_receive_raise_ticket(
      "subject" => "Remove user",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => %w[govt_form remove_user],
      "description" =>
"[Not before date]
31-12-#{next_year}

[User name]
Bob

[User email]
bob@someagency.gov.uk

[Reason for removal]
User has left the organisation",
    )

    user_requests_removal_of_another_user(
      user_name: "Bob",
      user_email: "bob@someagency.gov.uk",
      reason_for_removal: "User has left the organisation",
      not_before_day: "31",
      not_before_month: "12",
      not_before_year: next_year.to_s,
    )

    expect(request).to have_been_made
  end

private

  def user_requests_removal_of_another_user(details)
    visit "/"

    click_on "Remove user"

    expect(page).to have_content("Request to remove user access.")

    within("#new_support_requests_remove_user_request") do
      fill_in "User's name (required)", with: details[:user_name]
      fill_in "User's email (required)", with: details[:user_email]
      fill_in "Reason for removal", with: details[:reason_for_removal]
    end

    find("#not-before-day").set(details[:not_before_day])
    find("#not-before-month").set(details[:not_before_month])
    find("#not-before-year").set(details[:not_before_year])

    user_submits_the_request_successfully
  end
end
