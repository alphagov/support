require "rails_helper"

feature "Accounts, permissions and training requests" do
  # In order to allow departments to shift responsibilities around
  # As a departmental user manager
  # I want to request GDS tool access or new permissions for other users

  let(:user) { create(:user_manager, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  context "Other permissions" do
    scenario "user creation request" do
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

[Additional comments]
XXXX",
        },
      )

      user_creation_request = stub_zendesk_user_creation(
        email: "bob@gov.uk",
        name: "Bob Fields",
        details: "Job title: ",
        phone: nil,
        verified: true,
      )

      user_requests_a_change_to_other_user_accounts(
        action: "Create a new user account",
        user_name: "Bob Fields",
        user_email: "bob@gov.uk",
        additional_comments: "XXXX",
      )

      expect(ticket_request).to have_been_made
      expect(user_creation_request).to have_been_made
    end

    scenario "changing user permissions" do
      zendesk_has_user(email: "bob@gov.uk", name: "Bob Fields")

      ticket_request = expect_zendesk_to_receive_ticket(
        "subject" => "Change an existing user's account",
        "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
        "tags" => %w[govt_form change_user],
        "comment" => {
          "body" =>
"[Action]
Change an existing user's account

[Requested user's name]
Bob Fields

[Requested user's email]
bob@gov.uk

[Additional comments]
XXXX",
        },
      )

      user_requests_a_change_to_other_user_accounts(
        action: "Change an existing user's account",
        user_name: "Bob Fields",
        user_email: "bob@gov.uk",
        additional_comments: "XXXX",
      )

      expect(ticket_request).to have_been_made
    end
  end

private

  def user_requests_a_change_to_other_user_accounts(details)
    visit "/"

    click_on "Accounts, permissions and training"

    expect(page).to have_content("Request a new Whitehall account or change permissions.")

    within "#action" do
      choose details[:action]
    end

    within("#user_details") do
      fill_in "Name", with: details[:user_name]
      fill_in "Email", with: details[:user_email]
    end

    fill_in "Additional comments", with: details[:additional_comments]

    user_submits_the_request_successfully
  end
end
