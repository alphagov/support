When /^the user submits the following ERTP problem report:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  visit '/'

  click_on "Report an ERTP problem"

  assert page.has_content?("Report a an ERTP problem to GDS")

  fill_in "Details", with: @request_details['Details']
  fill_in "URL (if applicable)", with: @request_details['URL']

  step "the user submits the request successfully"
end
