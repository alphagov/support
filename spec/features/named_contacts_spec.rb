require "rails_helper"

feature "Named contacts" do
  # In order to resolve my GOV.UK-related issue
  # As a member of the public
  # I can ask GOV.UK User Support for help

  let(:user) { create(:user, name: "John Smith", email: "john.smith@email.co.uk") }

  background do
    login_as create(:api_user)
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "successful contact (to do with entire site)" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Named contact",
      "requester" => hash_including("name" => user.name, "email" => user.email),
      "tags" => %w[public_form named_contact],
      "comment" => {
        "body" =>
"[Requester]
John Smith <john.smith@email.co.uk>

[Details]
xyz

[Referrer]
https://www.gov.uk/x

[User agent]
Mozilla/5.0

[JavaScript Enabled]
true",
      },
    )

    post_json(
      "/named_contacts",
      "named_contact" => {
        "requester" => { "name" => user.name, "email" => user.email },
        "details"   => "xyz",
        "link" => nil,
        "user_agent" => "Mozilla/5.0",
        "javascript_enabled" => true,
        "referrer" => "https://www.gov.uk/x",
      },
    )

    expect(last_response.status).to eq(201)
    expect(request).to have_been_made
  end

  scenario "successful contact (to do with a specific page)" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Named contact about /y",
      "requester" => hash_including("name" => user.name, "email" => user.email),
      "tags" => %w[public_form named_contact],
      "comment" => {
        "body" =>
"[Requester]
John Smith <john.smith@email.co.uk>

[Details]
xyz

[Link]
https://www.gov.uk/y

[Referrer]
Unknown

[User agent]
Mozilla/5.0

[JavaScript Enabled]
true",
      },
    )

    post_json(
      "/named_contacts",
      "named_contact" => {
        "requester" => { "name" => user.name, "email" => user.email },
        "details"   => "xyz",
        "link" => "https://www.gov.uk/y",
        "user_agent" => "Mozilla/5.0",
        "javascript_enabled" => true,
        "referrer" => nil,
      },
    )

    expect(last_response.status).to eq(201)
    expect(request).to have_been_made
  end
end
