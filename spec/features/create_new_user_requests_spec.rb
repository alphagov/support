require "rails_helper"

feature "Create new user requests" do
  # In order to allow departments to shift responsibilities around
  # As a departmental user manager
  # I want to request GDS tool access or new permissions for other users

  let(:user) { create(:user_manager, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
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

    ticket_request = expect_support_api_to_receive_raise_ticket(
      "subject" => "Create a new user account",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "collaborators" => %w[bob@gov.uk],
      "tags" => %w[govt_form create_new_user],
      "description" =>
"[Action]
Create a new user account

[Requested user's name]
Bob Fields

[Requested user's email]
bob@gov.uk

[Organisation]
Cabinet Office (CO)

[Training or access to Whitehall Publisher]
No, the user does not need to draft or publish content on Whitehall Publisher

[Access to other publishing apps]
Yes, the user needs access to the applications and permissions listed below

[Additional comments]
XXXX",
    )
    visit "/"

    click_on "Create a new user"

    expect(page).to have_css("h1", text: "Create a new user")

    fill_in "User's name", with: "Bob Fields"
    fill_in "User's email", with: "bob@gov.uk"
    select "Cabinet Office (CO)", from: "User's organisation"
    choose "No, the user does not need to draft or publish content on Whitehall Publisher"
    choose "Yes, the user needs access to the applications and permissions listed below"
    fill_in "List any other publishing applications and permissions the user needs. If you’re not sure what these are, explain what tasks they need to be able to do.", with: "XXXX"

    user_submits_the_request_successfully

    expect(ticket_request).to have_been_made
  end
end
