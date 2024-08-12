require "rails_helper"

feature "Report an issue with GOV.UK search results" do
  let(:user) { create(:user, name: "John Smith", email: "john.smith@email.co.uk") }

  background do
    login_as user
  end

  scenario "successful request" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Report an issue with GOV.UK search results",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@email.co.uk"),
      "tags" => %w[govt_form site_search],
      "description" =>
"[What search query did you use?]
search-query

[What is the problem with the search results?]
search-result-problem

[What change do you want to make to the search results?]
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
    fill_in "What search query did you use, for example “Universal Credit”?", with: details[:search_query]
    fill_in "What is the problem with the search results?", with: details[:results_problem]
    fill_in "What change do you want to make to the search results? Include URLs for any pages you want the search to show.", with: details[:change_requested]
    fill_in "Explain why this change is necessary, including the impact on users and the number of users affected.", with: details[:change_justification]
    user_submits_the_request_successfully
  end
end
