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
      "subject" => "Needed by 12 Jan: My request title - Advice on content",
      "collaborators" => ["someone-else@example.com"],
      "description" =>
"[Needed by date]
12-01-#{next_year}

[Reason for time constraint]
Ministerial announcement Z

[Details]
[Advice needed]
This is the advice I need.",
    )

    visit new_content_advice_content_design_help_request_path

    fill_in "Title of request", with: "My request title"
    fill_in "What advice or help do you need?", with: "This is the advice I need."

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
