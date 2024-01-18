require "rails_helper"

feature "Create new user requests" do
  # In order to allow departments to shift responsibilities around
  # As a departmental user manager
  # I want to request GDS tool access or new permissions for other users

  let(:user) { create(:user_manager, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "user creation request" do
    stub_support_api_organisations_list([
      {
        slug: "cabinet-office",
        web_url: "https://www.gov.uk/government/organisations/cabinet-office",
        title: "Cabinet Office",
        acronym: "CO",
        govuk_status: "live",
      },
    ])

    zendesk_has_no_user_with_email("bob@gov.uk")

    ticket_request = expect_zendesk_to_receive_ticket(
      "subject" => "Create a new user account",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => %w[govt_form create_new_user],
      "comment" => {
        "body" =>
"[Action]
Create a new user account

[Requested user's name]
Bob Fields

[Requested user's email]
bob@gov.uk

[Organisation]
Cabinet Office (CO)

[Additional comments]
XXXX",
      },
    )

    user_creation_request = stub_zendesk_user_creation(
      email: "bob@gov.uk",
      name: "Bob Fields",
      verified: true,
    )

    visit "/"

    click_on "Create a new user"

    expect(page).to have_css("h1", text: "Create a new user")

    fill_in "User's name", with: "Bob Fields"
    fill_in "User's email", with: "bob@gov.uk"
    select "Cabinet Office (CO)", from: "User's organisation"
    fill_in "What additional publishing permissions does the user need?", with: "XXXX"

    user_submits_the_request_successfully

    expect(ticket_request).to have_been_made
    expect(user_creation_request).to have_been_made
  end
end
