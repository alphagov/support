require 'rails_helper'

feature "Create or change user requests" do
  # In order to allow departments to shift responsibilities around
  # As a departmental user manager
  # I want to request GDS tool access or new permissions for other users

  let(:user) { create(:user_manager, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  context "Whitehall user permissions" do
    scenario "user creation request" do
      zendesk_has_no_user_with_email("bob@gov.uk")

      ticket_request = expect_zendesk_to_receive_ticket(
        "subject" => "Create a new user account",
        "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
        "tags" => %w{govt_form create_new_user inside_government},
        "comment" => { "body" =>
"[Action]
Create a new user account

[User needs]
Editor - can create, review and publish content

[Requested user's name]
Bob Fields

[Requested user's email]
bob@gov.uk

[Requested user's job title]
Editor

[Requested user's phone number]
12345

[Requested user's training]
Writing for GOV.UK and Using Whitehall Publisher

[Requested user's other training]
Other training

[Additional comments]
XXXX"})

      user_creation_request = stub_zendesk_user_creation(
        email: "bob@gov.uk",
        name: "Bob Fields",
        details: "Job title: Editor",
        phone: "12345",
        verified: true,
      )

      user_requests_a_change_to_whitehall_user_accounts(
        action: "Create a new user account",
        user_needs: "Editor - can create, review and publish content",
        user_name: "Bob Fields",
        user_email: "bob@gov.uk",
        user_job_title: "Editor",
        user_phone: "12345",
        writing: true,
        using_publisher: true,
        other_training: "Other training",
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
        "tags" => %w{govt_form change_user inside_government},
        "comment" => { "body" =>
"[Action]
Change an existing user's account

[User needs]
Writer - can create content

[Requested user's name]
Bob Fields

[Requested user's email]
bob@gov.uk

[Requested user's training]
Writing for GOV.UK and Using Whitehall Publisher

[Requested user's other training]
Other training

[Additional comments]
XXXX"})

      user_requests_a_change_to_whitehall_user_accounts(
        action: "Change an existing user's account",
        user_needs: "Writer - can create content",
        user_name: "Bob Fields",
        user_email: "bob@gov.uk",
        writing: true,
        using_publisher: true,
        other_training: "Other training",
        additional_comments: "XXXX",
      )

      expect(ticket_request).to have_been_made
    end
  end

  context "Other permissions" do
    scenario "user creation request" do
      zendesk_has_no_user_with_email("bob@gov.uk")

      ticket_request = expect_zendesk_to_receive_ticket(
        "subject" => "Create a new user account",
        "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
        "tags" => %w{govt_form create_new_user},
        "comment" => { "body" =>
"[Action]
Create a new user account

[User needs]
Request changes to your organisation’s mainstream content

[Requested user's name]
Bob Fields

[Requested user's email]
bob@gov.uk

[Requested user's job title]
Editor

[Requested user's phone number]
12345

[Requested user's training]
Writing for GOV.UK and Using Whitehall Publisher

[Requested user's other training]
Other training

[Additional comments]
XXXX"})

      user_creation_request = stub_zendesk_user_creation(
        email: "bob@gov.uk",
        name: "Bob Fields",
        details: "Job title: Editor",
        phone: "12345",
        verified: true,
      )

      user_requests_a_change_to_other_user_accounts(
        action: "Create a new user account",
        user_needs: ["Request changes to your organisation’s mainstream content"],
        user_name: "Bob Fields",
        user_email: "bob@gov.uk",
        user_job_title: "Editor",
        user_phone: "12345",
        writing: true,
        using_publisher: true,
        other_training: "Other training",
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
        "tags" => %w{govt_form change_user},
        "comment" => { "body" =>
"[Action]
Change an existing user's account

[User needs]
Request changes to your organisation’s mainstream content\nAccess to Maslow database of user needs

[Requested user's name]
Bob Fields

[Requested user's email]
bob@gov.uk

[Requested user's training]
Writing for GOV.UK and Using Whitehall Publisher

[Requested user's other training]
Other training

[Additional comments]
XXXX"})

      user_requests_a_change_to_other_user_accounts(
        action: "Change an existing user's account",
        user_needs: ["Request changes to your organisation’s mainstream content", "Access to Maslow database of user needs"],
        user_name: "Bob Fields",
        user_email: "bob@gov.uk",
        writing: true,
        using_publisher: true,
        other_training: "Other training",
        additional_comments: "XXXX",
      )

      expect(ticket_request).to have_been_made
    end
  end

  private
  def user_requests_a_change_to_whitehall_user_accounts(details)
    visit '/'

    click_on "Accounts, permissions and training"

    expect(page).to have_content("Request a new account, change an account or unlock an account")

    within "#action" do
      choose details[:action]
    end

    within "#user-needs" do
      choose details[:user_needs]
    end

    within("#user_details") do
      fill_in "Name", with: details[:user_name]
      fill_in "Email", with: details[:user_email]
      fill_in "Job title", with: details[:user_job_title] if details[:user_job_title]
      fill_in "Phone number", with: details[:user_phone] if details[:user_phone]
      check "Writing for GOV.UK" if details[:writing]
      check "Using Whitehall Publisher" if details[:using_publisher]
      fill_in "Other, give details", with: details[:other_training]
    end

    fill_in "Additional comments", with: details[:additional_comments]

    user_submits_the_request_successfully
  end

  def user_requests_a_change_to_other_user_accounts(details)
    visit '/'

    click_on "Accounts, permissions and training"

    expect(page).to have_content("Request a new account, change an account or unlock an account")

    within "#action" do
      choose details[:action]
    end

    within "#other_permissions" do
      details[:user_needs].each do |user_need|
        check user_need
      end
    end

    within("#user_details") do
      fill_in "Name", with: details[:user_name]
      fill_in "Email", with: details[:user_email]
      fill_in "Job title", with: details[:user_job_title] if details[:user_job_title]
      fill_in "Phone number", with: details[:user_phone] if details[:user_phone]
      check "Writing for GOV.UK" if details[:writing]
      check "Using Whitehall Publisher" if details[:using_publisher]
      fill_in "Other, give details", with: details[:other_training]
    end

    fill_in "Additional comments", with: details[:additional_comments]

    user_submits_the_request_successfully
  end
end
