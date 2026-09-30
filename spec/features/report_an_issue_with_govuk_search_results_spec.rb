require "rails_helper"

feature "Report an issue with GOV.UK search results" do
  let(:user) { create(:user, name: "John Smith", email: "john.smith@email.co.uk") }

  background do
    login_as user
  end

  scenario "successful request" do
    request = expect_support_api_to_receive_raise_ticket(
      "subject" => "Report an issue with GOV.UK search results",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@email.co.uk"),
      "tags" => %w[govt_form site_search],
      "description" =>
"[What search queries are not working well?]
search-query

[What is the problem with the search results?]
search-result-problem

[Which pages are showing incorrectly and how should they be changed?]
improve-search-results

[Why is this change necessary?]
improvement-justification

[Is there evidence that users are searching for these queries?]
Not sure

[What is the evidence that users are searching for these queries?]
search-evidence-summary",
    )

    user_reports_issue_with_search_results(
      search_query: "search-query",
      results_problem: "search-result-problem",
      change_requested: "improve-search-results",
      change_justification: "improvement-justification",
      evidence_availability: "Not sure",
      evidence_description: "search-evidence-summary",
    )

    expect(request).to have_been_made
  end

  scenario "retains entered values when validation fails" do
    visit "/"
    click_on "Report an issue with GOV.UK search results"

    search_query = "search-query"
    change_requested = "improve-search-results"
    change_justification = "These results make it hard for users to find the right page."
    evidence_description = "Search analytics show users are entering this query."

    fill_in "What search queries are not working well?", with: search_query
    fill_in(
      "If applicable, which pages are missing, or showing too high or low in results? If the pages are showing do you think they should be higher, lower, or removed?",
      with: change_requested,
    )
    fill_in(
      "If applicable, explain why this change is necessary. Why are the current search results bad for users?",
      with: change_justification,
    )
    choose "No"
    fill_in(
      "If applicable, summarise the evidence that users are searching for these queries.",
      with: evidence_description,
    )

    click_on "Submit"

    expect(page).to have_field("What search queries are not working well?", with: search_query)
    expect(page).to have_field("If applicable, which pages are missing, or showing too high or low in results? If the pages are showing do you think they should be higher, lower, or removed?", with: change_requested)
    expect(page).to have_field("If applicable, explain why this change is necessary. Why are the current search results bad for users?", with: change_justification)
    expect(page).to have_checked_field("No")
    expect(page).to have_field("If applicable, summarise the evidence that users are searching for these queries.", with: evidence_description)
  end

private

  def user_reports_issue_with_search_results(details)
    visit "/"
    click_on "Report an issue with GOV.UK search results"
    expect(page).to have_content("Report an issue with GOV.UK search results")
    fill_in "What search queries are not working well?", with: details[:search_query]
    fill_in "What is the problem with the search results?", with: details[:results_problem]
    fill_in "If applicable, which pages are missing, or showing too high or low in results? If the pages are showing do you think they should be higher, lower, or removed?", with: details[:change_requested]
    fill_in "If applicable, explain why this change is necessary. Why are the current search results bad for users?", with: details[:change_justification]
    choose details[:evidence_availability]
    fill_in "If applicable, summarise the evidence that users are searching for these queries.", with: details[:evidence_description]
    user_submits_the_request_successfully
  end
end
