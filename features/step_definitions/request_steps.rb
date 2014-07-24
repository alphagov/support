When /^the user fills out the time constraints$/ do
  fill_in "MUST be published by", :with => @request_details["Needed by date"]
  fill_in "MUST NOT be published BEFORE", :with => @request_details["Not before date"]
  fill_in "Reason for the above dates", :with => @request_details["Reason"]
end

When /^the user submits the request successfully$/ do
  click_on "Submit"
  assert page.has_content?("You should receive a confirmation email shortly."), page.html
end

When /^the user submits the following new feature request:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  visit '/'

  click_on "New feature/need"

  assert page.has_content?("Request a new feature/need")

  fill_in "Title of request", with: @request_details["Title"] if @request_details["Title"]

  within "#request-context" do
    choose @request_details["Context"]
  end

  fill_in "What is the user need/feature request?", :with => @request_details['User need']
  fill_in "Can you provide a link to an example of this feature?", :with => @request_details['URL of example']

  step "the user fills out the time constraints"
  step "the user submits the request successfully"
end

When /^the user submits the following content change request:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  visit '/'

  click_on "Content change"

  assert page.has_content?("Request a change")

  within "#request-context" do
    choose @request_details["Context"]
  end

  fill_in "Title of request", :with => @request_details["Title"] unless @request_details["Title"].nil?
  fill_in "Details of the requested change", :with => @request_details["Details of change"]
  fill_in "URL", :with => @request_details["URL"]
  fill_in "Does this affect any other URLs? (please specify one per line)", :with => @request_details["Related URLs"]

  step "the user fills out the time constraints"
  step "the user submits the request successfully"
end

When /^the user submits the following request to create or change users:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  visit '/'

  click_on "Create or change user"

  assert page.has_content?("Create or change a user account")

  within "#action" do
    choose @request_details["Action"]
  end

  within "#user-needs" do
    @request_details["User needs"].split(", ").each do |user_need|
      check user_need
    end
  end

  within("#user_details") do
    fill_in "Name", :with => @request_details["User's name"]
    fill_in "Email", :with => @request_details["User's email"]
    fill_in "Job title", :with => @request_details["User's job title"]
    fill_in "Phone number", :with => @request_details["User's phone"]
  end

  fill_in "Additional comments", :with => @request_details["Additional comments"]

  step "the user submits the request successfully"
end

When /^the user submits the following remove user request:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  visit '/'

  click_on "Remove user"

  assert page.has_content?("Request to remove user access")

  within("#user_details") do
    fill_in "Name", :with => @request_details["User's name"]
    fill_in "Email", :with => @request_details["User's email"]
    fill_in "Reason for removal", :with => @request_details["Reason for removal"]
  end

  fill_in "MUST NOT be removed BEFORE", :with => @request_details["Not before date"]

  step "the user submits the request successfully"
end
