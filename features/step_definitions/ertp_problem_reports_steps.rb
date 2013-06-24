When /^the user submits the following ERTP problem report:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  visit '/'

  click_on "Report an ERTP problem"

  assert page.has_content?("Report a an ERTP problem to GDS")

  fill_in "Control Center ticket number", with: @request_details['CC ticket #']
  fill_in "Local authority impacted", with: @request_details['Local authority']
  check "Multiple local authorities impacted?" if @request_details['Multiple LAs'] == "true"
  
  fill_in "Describe the problem", with: @request_details['Problem description']
  fill_in "What has been done to ensure that this is a GDS problem?", with: @request_details['Investigation']
  fill_in "Issue category", with: @request_details['Issue category']
  fill_in "Additional details", with: @request_details['Additional']

  step "the user submits the request successfully"
end
