require "rails_helper"

feature "Change existing user requests" do
  # In order to allow departments to shift responsibilities around
  # As a departmental user manager
  # I want to request GDS tool access or new permissions for other users

  let(:user) { create(:user_manager, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "changing user permissions" do
    zendesk_has_user(email: "bob@gov.uk", name: "Bob Fields")

    ticket_request = expect_zendesk_to_receive_ticket(
      "subject" => "Change an existing user's account",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => %w[govt_form change_user],
      "description" =>
"[Action]
Change an existing user's account

[Requested user's name]
Bob Fields

[Requested user's email]
bob@gov.uk

[Additional comments]
XXXX",
    )

    visit "/"

    click_on "Change an existing user's account"

    expect(page).to have_css("h1", text: "Change an existing user's account")

    fill_in "User's name", with: "Bob Fields"
    fill_in "User's email", with: "bob@gov.uk"

    fill_in "What do you want to change?", with: "XXXX"

    user_submits_the_request_successfully

    expect(ticket_request).to have_been_made
  end
end
