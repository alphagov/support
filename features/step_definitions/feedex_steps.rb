require 'date'

Before do
  Support::Requests::Anonymous::AnonymousContact.delete_all
end

Given /^the following problem reports have been left by members of the public:$/ do |table|
  table.hashes.each do |problem_report_details|
    problem_report = Support::Requests::Anonymous::ProblemReport.create!(
      url: problem_report_details["URL"],
      referrer: problem_report_details["User came from"],
      what_doing: problem_report_details["What user was doing"],
      what_wrong: problem_report_details["What went wrong"],
      javascript_enabled: true
    )
    problem_report.created_at = Date.strptime(problem_report_details["Creation date"], '%Y-%m-%d')
    problem_report.save
  end
end

When /^the user explores the feedback with the following filters:$/ do |table|
  explore_details = table.hashes.first

  visit "/"

  click_on "Feedback explorer"

  assert page.has_content?("FeedEx"), page.html

  fill_in 'By URL', with: explore_details["URL"]

  click_on "Explore"

  assert page.has_content?("Anonymous feedback for"), page.html
end

Then /^the following result is shown:$/ do |table|
  actual = find('table#results').all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }

  table.diff!(actual)
end
