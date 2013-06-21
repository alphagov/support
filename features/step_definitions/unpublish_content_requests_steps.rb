When /^the user submits the following request to unpublish content:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  visit '/'

  click_on "Unpublish content"

  assert page.has_content?("Request to unpublish content")

  fill_in "Which content does this concern (provide one or more urls)?", with: @request_details['URL']

  within "#unpublish-reason" do
    choose @request_details["Reason"]
  end

  fill_in "Further explanation (this explanation can be published)", with: @request_details['Further explanation']

  step "the user submits the request successfully"
end
