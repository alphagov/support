require "rails_helper"

feature "New feature requests" do
  # In order to fulfill user needs not currently met by gov.uk
  # As a government employee
  # I want a means to contact GDS and request new features

  let(:user) { create(:content_requester, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
  end

  scenario "successful request" do
    request = expect_support_api_to_receive_raise_ticket(
      "subject" => "Abc",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => %w[govt_form new_feature_request],
      "description" =>
"[User need]
Information on XYZ

[Feature evidence]
See here: google.com",
    )

    user_makes_a_new_feature_request(
      title: "Abc",
      user_need: "Information on XYZ",
      feature_evidence: "See here: google.com",
    )

    expect(request).to have_been_made
  end

private

  def user_makes_a_new_feature_request(details)
    visit "/"

    click_on "Changes to publishing applications or technical advice"

    expect(page).to have_content("Give as much detail as you can about the user need and evidence for your request.")

    fill_in "Title of request", with: details[:title]

    fill_in "What is the product request or technical advice you need?", with: details[:user_need]
    fill_in "If this is a request for a new feature, what evidence do you have to support the request?", with: details[:feature_evidence]

    user_submits_the_request_successfully
  end
end
