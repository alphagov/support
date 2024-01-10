require "rails_helper"

feature "Create user requests" do
  let(:user) { create(:user_manager, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
    zendesk_has_user(email: user.email, suspended: false)
  end

  context "Non-Whitehall account" do
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
cabinet-office

[Other apps]
Licensing",
        },
      )

      user_creation_request = stub_zendesk_user_creation(
        email: "bob@gov.uk",
        name: "Bob Fields",
        details: "Job title: ",
        phone: nil,
        verified: true,
      )

      user_requests_a_new_user_account(
        user_name: "Bob Fields",
        user_email: "bob@gov.uk",
        organisation: "Cabinet Office (CO)",
        other_apps: "Licensing",
      )

      expect(ticket_request).to have_been_made
      expect(user_creation_request).to have_been_made
    end
  end

private

  def user_requests_a_new_user_account(details)
    visit "/"

    click_on "Request a new user account"

    expect(page).to have_css("h1", text: "Request a new user account")

    fill_in "User's name", with: details[:user_name]
    fill_in "User's email", with: details[:user_email]
    select details[:organisation], from: "Organisation"
    fill_in "Does the user need access to additional publishing applications?", with: details[:other_apps]

    user_submits_the_request_successfully
  end
end
