require "rails_helper"

feature "Create new user or training requests" do
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
      "subject" => "Create a new user or request training",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "collaborators" => %w[bob@gov.uk],
      "tags" => %w[govt_form create_new_user],
      "description" =>
"[Action]
Create a new user or request training

[Requested user's name]
Bob Fields

[Requested user's email]
bob@gov.uk

[Organisation]
Cabinet Office (CO)

[New or existing user]
They’re a new user and do not have a Production account

[Training or access to Whitehall Publisher]
No, the user does not need to draft or publish content on Whitehall Publisher

[Access to other publishing apps]
Yes, the user needs access to the applications and permissions listed below

[Writing for GOV.UK training]
No, the user does not need Writing for GOV.UK training

[Additional comments]
XXXX",
      "custom_fields" => [
        { "id" => 16_186_374_142_108, "value" => "Bob Fields" },
        { "id" => 16_186_377_836_316, "value" => "bob@gov.uk" },
        { "id" => 18_626_821_668_764, "value" => "whitehall_training_new_user" },
        { "id" => 16_186_461_678_108, "value" => "whitehall_training_required_none" },
        { "id" => 16_186_526_602_396, "value" => "whitehall_training_additional_apps_access_yes" },
        { "id" => 16_186_432_238_236, "value" => "Cabinet Office (CO)" },
        { "id" => 18_626_967_621_276, "value" => "whitehall_training_writing_for_govuk_required_no" },
      ],
      "ticket_form_id" => 16_186_592_181_660,
    )
    visit "/"

    click_on "Create a new user"

    expect(page).to have_css("h1", text: "Create a new user")

    fill_in "User's name", with: "Bob Fields"
    fill_in "User's email", with: "bob@gov.uk"
    select "Cabinet Office (CO)", from: "User's organisation"
    choose "They’re a new user and do not have a Production account"
    choose "No, the user does not need to draft or publish content on Whitehall Publisher"
    choose "Yes, the user needs access to the applications and permissions listed below"
    fill_in "List any other publishing applications and permissions the user needs. If you’re not sure what these are, explain what tasks they need to be able to do.", with: "XXXX"
    choose "No, the user does not need Writing for GOV.UK training"

    user_submits_the_request_successfully

    expect(ticket_request).to have_been_made
  end
end
