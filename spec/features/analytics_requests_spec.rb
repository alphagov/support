require 'rails_helper'

feature "Analytics requests" do
  let(:user) { create(:content_requester, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "successful request" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Request for analytics",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => [ "govt_form", "analytics" ],
      "comment" => { "body" =>
"[Google Analytics Access]
Sarah Jones sarah@example.com some area

[Single Point of Contact]
Government Digital Service

[Report Request]
/my-page

[Help]
Need help with cats"})

    visit '/'

    click_on "Analytics access, reports and help"

    expect(page).to have_content("Only department/organisation Analytics Single Point of Contact (SPOC) can request access.")

    fill_in "Access to Google Analytics",
      with: "Sarah Jones sarah@example.com some area"

    fill_in "Tell me who my Analytics Single Point of Contact (SPOC) is",
      with: "Government Digital Service"

    fill_in "Analytics Report Request",
      with: "/my-page"

    fill_in "Analytics Help",
      with: "Need help with cats"

    user_submits_the_request_successfully

    expect(request).to have_been_made
  end

  scenario 'submitting a form with no inputs fails and shows a flash message' do
    visit '/'

    click_on "Analytics access, reports and help"

    click_on "Submit"

    expect(page).to have_content("Only department/organisation Analytics Single Point of Contact (SPOC) can request access.")
    expect(page).to have_content 'Please enter details for at least one type of request'
  end
end
