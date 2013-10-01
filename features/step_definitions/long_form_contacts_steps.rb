When /^the user submits the following Long form contact:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  visit '/'

  click_on "Long form contact"

  assert page.has_content?("Some description of the request here")

  fill_in "Details", with: @request_details['Details']
  fill_in "URL (if applicable)", with: @request_details['URL']

  step "the user submits the request successfully"
end
