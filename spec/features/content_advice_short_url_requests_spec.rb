require "rails_helper"

feature "Request for a group page" do
  let(:user) { create(:content_requester) }
  let(:next_year) { Time.zone.now.year.succ }

  background do
    login_as user
  end

  scenario "successful request" do
    request = expect_support_api_to_receive_raise_ticket(
      "tags" => %w[govt_form dept_content_advice],
      "priority" => "normal",
      "subject" => "Needed by 12 Jan: Short URL Test request - Advice on content",
      "collaborators" => ["someone-else@example.com"],
      "description" =>
"[Needed by date]
12-01-#{next_year}

[Reason for time constraint]
Ministerial announcement Z

[Details]
[Destination page]
/guidance/blah with a suggested short url of /blah

[Reason]
This is the reason

[Usage]
This is how it will be used

[Marketing message]
This is the marketing message

[Organisations using url]
These are the organisations using the url

[Additional info]
This is the additional info",
    )

    visit new_content_advice_short_url_request_path

    fill_in "Title of request", with: "Short URL Test request"
    fill_in "What short URL do you want?", with: "/guidance/blah with a suggested short url of /blah"
    fill_in "Why do you want a short URL?", with: "This is the reason"
    fill_in "How will you use the short URL? ", with: "This is how it will be used"
    fill_in "What’s the main message of the marketing and communications that will use the short URL?", with: "This is the marketing message"
    fill_in "Which government organisations will use the short URL?", with: "These are the organisations using the url"
    fill_in "Is there any more information you want to share about your request?", with: "This is the additional info"

    within_fieldset("Is there a deadline?") do
      choose "Yes"
      fill_in "Day", with: "12"
      fill_in "Month", with: "01"
      fill_in "Year", with: next_year.to_s
      fill_in "What’s the reason for the deadline?", with: "Ministerial announcement Z"
    end

    fill_in "Who needs a copy of this request?", with: "someone-else@example.com"

    user_submits_the_request_successfully

    expect(request).to have_been_made
  end
end
