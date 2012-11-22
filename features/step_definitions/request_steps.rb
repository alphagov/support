When /^the user fills out their details$/ do
  fill_in "Name", :with => @user_details["Name"]
  fill_in "Email", :with => @user_details["Email"]
  fill_in "Job title", :with => @user_details["Job title"]
  fill_in "Phone number", :with => @user_details["Phone"]
  select @user_details["Organisation"], :from => 'Organisation'  
end

When /^the user fills out the time constraints$/ do
  fill_in "MUST be published by", :with => @request_details["Needed by date"]
  fill_in "MUST NOT be published BEFORE", :with => @request_details["Not before date"]
  fill_in "Reason for the above dates", :with => @request_details["Reason"]  
end

When /^the user submits the request successfully$/ do
  click_on "Submit"
  assert page.has_content?("Your ticket has been submitted successfully")
end

When /^the user submits the following general request:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  visit '/'

  click_on "General"

  assert page.has_content?("Report a problem")

  step "the user fills out their details"

  fill_in "Details", :with => @request_details['Details']
  fill_in "URL (if applicable)", :with => @request_details['URL']

  step "the user submits the request successfully"
end

When /^the user submits the following new feature request:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  visit '/'

  click_on "New feature/need"

  assert page.has_content?("Request a new feature/need")

  step "the user fills out their details"

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

  step "the user fills out their details"

  fill_in "Details of the requested change", :with => @request_details["Details of change"]
  fill_in "URL 1", :with => @request_details["URL 1"]
  fill_in "URL 2", :with => @request_details["URL 2"]
  fill_in "URL 3", :with => @request_details["URL 3"]

  step "the user fills out the time constraints"
  step "the user submits the request successfully"
end

When /^the user submits the following create user request:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  visit '/'

  click_on "Create new user"

  assert page.has_content?("Create a new user account")

  step "the user fills out their details"

  within("#user_details") do
    fill_in "Name", :with => @request_details["User's name"]
    fill_in "Email", :with => @request_details["User's email"]
    fill_in "Additional comments (specify editor or writer as required for Inside Government)", :with => @request_details["Additional comments"]
  end

  step "the user submits the request successfully"
end