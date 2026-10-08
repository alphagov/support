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
      "subject" => "Needed by 12 Jan: My new group - group page request - Advice on content",
      "collaborators" => ["someone-else@example.com"],
      "description" =>
"[Needed by date]
12-01-#{next_year}

[Reason for time constraint]
Ministerial announcement Z

[Details]
[Group name]
My new group

[Purpose]
Testing group

[User needs evidence]
This is the user needs evidence

[Contact reason]
This is the contact reason

[Additional info]
This is the additional info",
    )

    visit "/content_advice/group_page_request/new"

    fill_in "What’s the name of the group?", with: "My new group"
    fill_in "What’s the group's purpose?", with: "Testing group"
    fill_in "What evidence do you have of a user need for information about the group itself, not just its outputs?", with: "This is the user needs evidence"
    fill_in "Is there a clear reason for users to contact the group?", with: "This is the contact reason"
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
