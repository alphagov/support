require "rails_helper"

feature "FOI requests" do
  # In order to learn about government actions that aren't openly documented yet
  # As a member of the public
  # I want to lodge a 'freedom of information' request

  let(:user) { create(:user, name: "John Smith", email: "john.smith@email.co.uk") }

  background do
    login_as create(:api_user)
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "successful request" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "FOI",
      "requester" => hash_including("name" => user.name, "email" => user.email),
      "tags" => %w[public_form foi_request],
      "comment" => {
        "body" =>
"[Name]
John Smith

[Email]
john.smith@email.co.uk

[Details]
xyz",
      },
    )

    post_json(
      "/foi_requests",
      "foi_request" => {
        "requester" => { "name" => user.name, "email" => user.email },
        "details"   => "xyz",
      },
    )

    expect(last_response.status).to eq(201)
    expect(request).to have_been_made
  end
end
