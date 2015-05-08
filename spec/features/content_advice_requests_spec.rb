require 'rails_helper'

feature "Request for content advice" do
  # In order to publish my department or agency's content in a way that best meets user need
  # As a departmental/agency content designer
  # I want to contact the GOV.UK Content team for advice

  let(:user) { create(:user) }

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "successful request" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Needed by 12 Jan: Which format - Advice on content",
      "tags" => [ "govt_form", "dept_content_advice" ],
      "comment" => { "body" =>
"[Nature of the request]
Initial guidance from GOV.UK on content you are working on

[Details]
I need help to choose a format, here's my content...

[Relevant URLs]
https://www.gov.uk/x, https://www.gov.uk/y

[Date needed by]
12-01-2020

[Reason for deadline]
Ministerial announcement Z

[Contact number]
0121 111111"})

    user_requests_content_advice(
      title: "Which format",
      nature_of_request: "Initial guidance from GOV.UK",
      details: "I need help to choose a format, here's my content...",
      urls: "https://www.gov.uk/x, https://www.gov.uk/y",
      needed_by: "12-01-2020",
      reason_for_deadline: "Ministerial announcement Z",
      contact_number: "0121 111111",
    )

    expect(request).to have_been_made
  end

  scenario "successful request with other reaason" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Tricky query - Advice on content",
      "tags" => [ "govt_form", "dept_content_advice" ],
      "comment" => { "body" =>
"[Nature of the request]
some details

[Details]
I have a tricky query, here's my content...

[Relevant URLs]
https://www.gov.uk/x, https://www.gov.uk/y

[Contact number]
0121 111111"})

    user_requests_content_advice(
      title: "Tricky query",
      nature_of_request: "Other - please give information",
      nature_of_request_details: "some details",
      details: "I have a tricky query, here's my content...",
      urls: "https://www.gov.uk/x, https://www.gov.uk/y",
      contact_number: "0121 111111",
    )

    expect(request).to have_been_made
  end

  private
  def user_requests_content_advice(details)
    visit '/'

    click_on "Content advice"
    expect(page).to have_content("Ask for advice and guidance on Departments and Policy content")

    fill_in "Title of request", with: details[:title]
    choose details[:nature_of_request]
    fill_in 'support_requests_content_advice_request_nature_of_request_details',
      with: details[:nature_of_request_details] if details[:nature_of_request_details]
    fill_in "Please explain what you would like help with", with: details[:details]
    fill_in "Relevant URLs (if applicable)", with: details[:urls]

    fill_in "Is there a date you need to have a response by?", with: details[:needed_by]
    fill_in "Reason for deadline", with: details[:reason_for_deadline]
    fill_in "Contact telephone number (in case we need to call you to discuss the content)",
      with: details[:contact_number]

    user_submits_the_request_successfully
  end
end
