require "gds_api/test_helpers/support_api"

module AppActions
  include GdsApi::TestHelpers::SupportApi

  def explore_anonymous_feedback_by_urls(list_of_urls: nil, uploaded_list: nil)
    visit "/"

    stub_support_api_organisations_list
    stub_support_api_document_type_list

    click_on "Feedback explorer"
    assert page.has_title?("Anonymous Feedback"), page.html

    if list_of_urls
      fill_in "URL(s)", with: list_of_urls
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

    select organisation, from: "Organisation"
    click_on "Explore by organisation"

    expect(page).to have_content("Feedback for")
  end

  def explore_anonymous_feedback_by_document_type(document_type)
    visit "/"

    stub_support_api_document_type_list

    click_on "Feedback explorer"
    assert page.has_title?("Anonymous Feedback"), page.html

    select document_type, from: "Document Type"
    click_on "Explore by document type"

    expect(page).to have_content("Feedback for")
  end

  def feedex_results
    all_cells = find("table#results").all("tr").map { |row| row.all("th, td").map { |cell| cell.text.strip } }
    first_row = all_cells[0]
    results = all_cells[1..]
    results.collect { |row| Hash[first_row.zip(row)] }
  end

  def organisation_summary_results
    column_headings = find("table tr.table-header").all("th")
      .map { |cell| cell.text.strip }
    summary_rows = find("table").all("tr.organisation-summary")
      .map { |row| row.all("td").map { |cell| cell.text.strip } }

    summary_rows.map { |row| Hash[column_headings.zip(row)] }
  end

  def doctype_summary_results
    column_headings = find("table tr.table-header").all("th")
      .map { |cell| cell.text.strip }
    summary_rows = find("table").all("tr.doctype-summary")
      .map { |row| row.all("td").map { |cell| cell.text.strip } }

    summary_rows.map { |row| Hash[column_headings.zip(row)] }
  end

  def user_fills_out_time_constraints(details)
    fill_in "Deadline", with: details[:needed_by_date]
    fill_in "Time this must be published by", with: details[:needed_by_time]
    fill_in "Must not be published before", with: details[:not_before_date]
    fill_in "Time this must not be published before", with: details[:not_before_time]
    fill_in "Reason for deadline", with: details[:reason]
  end

  def user_submits_the_request_successfully(button_text: "Submit")
    click_on button_text
    expect(page).to have_content("Thanks for sending us your request. We'll review your request and get back to you within 2 working days.")
  end
end

RSpec.configure { |c| c.include AppActions }
