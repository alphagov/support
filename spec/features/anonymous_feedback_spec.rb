require 'rails_helper'

feature "Anonymous feedback" do
  # In order to fix and improve GOV.UK
  # As a GDS employee
  # I want to capture bugs, gripes and improvement suggestions submitted by the general public

  background do
    zendesk_has_no_user_with_email(ZENDESK_ANONYMOUS_TICKETS_REQUESTER_EMAIL)
    login_as create(:api_user)
  end

  scenario "successful problem report submission" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "/x/y",
      "requester" => hash_including("email" => ZENDESK_ANONYMOUS_TICKETS_REQUESTER_EMAIL),
      "tags" => %w{anonymous_feedback public_form report_a_problem inside_government govuk_referrer page_owner/hmrc},
      "comment" => { "body" =>
"url: https://www.gov.uk/x/y
what_doing: Eating sandwich
what_wrong: Fell on floor
user_agent: Safari
referrer: https://www.gov.uk/z
javascript_enabled: true"})

    post_json '/anonymous_feedback/problem_reports', {
      "problem_report" => {
        "what_doing" => "Eating sandwich",
        "what_wrong" => "Fell on floor",
        "url" => "https://www.gov.uk/x/y",
        "user_agent" => "Safari",
        "javascript_enabled" => true,
        "referrer" => "https://www.gov.uk/z",
        "source" => "inside_government",
        "page_owner" => "hmrc",
      }
    }

    expect(last_response.status).to eq(201)
    expect(request).to have_been_made
  end
end
