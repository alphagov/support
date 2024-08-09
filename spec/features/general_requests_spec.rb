require "rails_helper"

feature "General requests" do
  # In order to request something that doesn't fit into any other GOV.UK support contact route
  # As a government user
  # I want to contact the GOV.UK Support team

  let(:user) { create(:user, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
  end

  scenario "successful request" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Downtime - Govt Agency General Issue",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => %w[govt_form govt_agency_general],
      "description" =>
"[Url]
https://www.gov.uk

[Details]
The site is down",
    )

    user_makes_a_general_request(
      title: "Downtime",
      details: "The site is down",
      url: "https://www.gov.uk",
    )

    expect(request).to have_been_made
  end

private

  def user_makes_a_general_request(details)
    visit "/"

    click_on "General"

    expect(page).to have_content("report planned departmental changes that affect GOV.UK and its users")

    fill_in "Title of request", with: details[:title]
    fill_in "Details", with: details[:details]
    fill_in "URL (if applicable)", with: details[:url]

    user_submits_the_request_successfully
  end
end
