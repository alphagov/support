require "rails_helper"

feature "Request for content advice" do
  # In order to publish my department or agency's content in a way that best meets user need
  # As a departmental/agency content designer
  # I want to contact the GOV.UK Content team for advice

  let(:user) { create(:content_requester) }
  let(:next_year) { Time.zone.now.year.succ }

  background do
    login_as user
  end

  scenario "successful request" do
    request = expect_support_api_to_receive_raise_ticket(
      "subject" => "Needed by 12 Jan: Which format - Advice on content",
      "tags" => %w[govt_form dept_content_advice],
      "description" =>
"[Needed by date]
12-01-#{next_year}

[Reason for time constraint]
Ministerial announcement Z

[Details]
I need help to choose a format, here's my content...

[Relevant URLs]
https://www.gov.uk/x, https://www.gov.uk/y

[Contact number]
0121 111111",
    )

    user_requests_content_advice(
      title: "Which format",
      details: "I need help to choose a format, here's my content...",
      urls: "https://www.gov.uk/x, https://www.gov.uk/y",
      needed_by_day: "12",
      needed_by_month: "01",
      needed_by_year: next_year.to_s,
      reason_for_deadline: "Ministerial announcement Z",
      contact_number: "0121 111111",
    )

    expect(request).to have_been_made
  end

  scenario "successful request with other reaason" do
    request = expect_support_api_to_receive_raise_ticket(
      "subject" => "Tricky query - Advice on content",
      "tags" => %w[govt_form dept_content_advice],
      "description" =>
"[Details]
I have a tricky query, here's my content...

[Relevant URLs]
https://www.gov.uk/x, https://www.gov.uk/y

[Contact number]
0121 111111",
    )

    user_requests_content_advice(
      title: "Tricky query",
      details: "I have a tricky query, here's my content...",
      urls: "https://www.gov.uk/x, https://www.gov.uk/y",
      contact_number: "0121 111111",
    )

    expect(request).to have_been_made
  end

private

  def user_requests_content_advice(details)
    visit "/"

    click_on "Content advice and help"
    expect(page).to have_content("Ask for help or advice on any content problems")

    fill_in "Title of request", with: details[:title]
    fill_in "Please explain what you would like help with", with: details[:details]
    fill_in "Relevant URLs (if applicable)", with: details[:urls]
    find("#needed-by-day").set(details[:needed_by_day])
    find("#needed-by-month").set(details[:needed_by_month])
    find("#needed-by-year").set(details[:needed_by_year])
    fill_in "Reason for deadline", with: details[:reason_for_deadline]
    fill_in "Contact telephone number",
            with: details[:contact_number]

    user_submits_the_request_successfully
  end
end
