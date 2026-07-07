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
improvement-justification",
    )

    user_reports_issue_with_search_results(
      search_query: "search-query",
      results_problem: "search-result-problem",
      change_requested: "improve-search-results",
      change_justification: "improvement-justification",
    )

    expect(request).to have_been_made
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
    user_submits_the_request_successfully
  end
end
