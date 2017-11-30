require 'gds_api/test_helpers/support_api'

module AppActions
  include GdsApi::TestHelpers::SupportApi

  def explore_anonymous_feedback_by_urls(list_of_urls: nil, uploaded_list: nil)
    visit "/"

    stub_support_api_organisations_list

    click_on "Feedback explorer"
    assert page.has_title?("Anonymous Feedback"), page.html

    if list_of_urls
      fill_in 'URL(s)', with: list_of_urls
      click_on "Explore by URL"
    elsif uploaded_list
      attach_file("Upload list of URLs", uploaded_list)
      click_on "Upload list of urls"
    end

    expect(page).to have_content("Feedback for")
  end

  def explore_anonymous_feedback_by_organisation(organisation)
    visit "/"

    stub_support_api_organisations_list

    click_on "Feedback explorer"
    assert page.has_title?("Anonymous Feedback"), page.html

    select organisation, from: 'Organisation'
    click_on "Explore by organisation"

    expect(page).to have_content("Feedback for")
  end

  def feedex_results
    all_cells = find('table#results').all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }
    first_row = all_cells[0]
    results = all_cells[1..-1]
    results.collect { |row| Hash[first_row.zip(row)] }
  end

  def organisation_summary_results
    column_headings = find("table tr.table-header").all("th").
      map { |cell| cell.text.strip }
    summary_rows = find("table").all("tr.organisation-summary").
      map { |row| row.all("td").map { |cell| cell.text.strip } }

    summary_rows.map { |row| Hash[column_headings.zip(row)] }
  end

  def user_fills_out_time_constraints(details)
    fill_in "MUST be published by", with: details[:needed_by_date]
    fill_in "MUST NOT be published BEFORE", with: details[:not_before_date]
    fill_in "Reason for the above dates", with: details[:reason]
  end

  def user_submits_the_request_successfully
    click_on "Submit"
    expect(page).to have_content("You should receive a confirmation email shortly.")
  end
end

RSpec.configure { |c| c.include AppActions }
