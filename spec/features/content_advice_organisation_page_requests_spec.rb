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
      "subject" => "Needed by 12 Jan: My new organisation - organisation page request - Advice on content",
      "collaborators" => ["someone-else@example.com"],
      "description" =>
"[Needed by date]
12-01-#{next_year}

[Reason for time constraint]
Ministerial announcement Z

[Details]
[Organisation name]
My new organisation

[Organisation abbreviation]
MNO

[Logo type]
Single identity system

[Logo format]
Stacked

[Parent organisation]
A parent organisation

[Organisation type]
Court

[Organisation status]
Coming soon

[Associated organisations]
Some associated orgs

[Alternative format email]
alt-format@example.com

[Govuk lead name]
Test Person

[Govuk lead email]
test-person@example.com

[Additional info]
Additional info",
    )

    visit new_content_advice_organisation_page_request_path

    fill_in "What’s the name of the organisation?", with: "My new organisation"
    fill_in "What’s the organisation’s abbreviation (if it has one)?", with: "MNO"
    within_fieldset("What sort of logo will the organisation use?") do
      choose "Single identity system"
    end
    fill_in "support_requests_content_advice_organisation_page_request[sis_logo_format]", with: "Stacked"
    fill_in "Who’s the parent or sponsoring organisation?", with: "A parent organisation"
    within_fieldset("What’s the organisation type?") do
      choose "Court"
    end
    fill_in "What’s the alternative format email address?", with: "alt-format@example.com"
    within_fieldset("What’s the organisation’s status?") do
      choose "Coming soon"
    end
    fill_in "Are there any other associated or sponsoring organisations?", with: "Some associated orgs"
    fill_in "Who is the GOV.UK lead for the organisation?", with: "Test Person"
    fill_in "What is the GOV.UK lead's email address?", with: "test-person@example.com"
    fill_in "Is there any more information you want to share about your request?", with: "Additional info"
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
