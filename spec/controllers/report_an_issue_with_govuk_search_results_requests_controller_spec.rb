require "rails_helper"

describe ReportAnIssueWithGovukSearchResultsRequestsController, type: :controller do
  render_views

  before do
    login_as create(:user)
  end

  it "re-displays the form with error messages if validation fails" do
    post :create, params: { "support_requests_report_an_issue_with_govuk_search_results_request" => {
      search_query: "",
    } }

    expect(controller).to have_rendered(:new)
    expect(response.body).to have_css(".alert", text: /Search query can't be blank/)
    expect(response.body).to have_css(".alert", text: /Results problem can't be blank/)
    expect(response.body).to have_css(".alert", text: /Change requested can't be blank/)
    expect(response.body).to have_css(".alert", text: /Change justification can't be blank/)
  end
end
