require 'gds_api/test_helpers/organisations'

module AppActions
  include GdsApi::TestHelpers::Organisations

  def explore_anonymous_feedback_with(options)
    visit "/"

    stub_organisations_api

    click_on "Feedback explorer"
    assert page.has_title?("Anonymous Feedback"), page.html
    fill_in 'URL', with: options[:url]

    click_on "Explore"

    expect(page).to have_content("Feedback for")
  end

  def stub_organisations_api
    organisations_slugs = %w(department-of-fair-dos)
    organisations_api_has_organisations(organisations_slugs)
  end

  def feedex_results
    all_cells = find('table#results').all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }
    first_row, results = all_cells[0], all_cells[1..-1]
    results.collect { |row| Hash[first_row.zip(row)] }
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
