When /^the user fills out the time constraints$/ do
  fill_in "MUST be published by", :with => @request_details["Needed by date"]
  fill_in "MUST NOT be published BEFORE", :with => @request_details["Not before date"]
  fill_in "Reason for the above dates", :with => @request_details["Reason"]  
end

When /^the user submits the request successfully$/ do
  click_on "Submit"
  assert page.has_content?("Your submission should be confirmed shortly."), page.html
end

When /^the user submits the following general request:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  visit '/'

  click_on "General"

  assert page.has_content?("Report a problem")

  fill_in "Title of request", with: @request_details["Title"] if @request_details["Title"]
  fill_in "Details", :with => @request_details['Details']
  fill_in "URL (if applicable)", :with => @request_details['URL']

  step "the user submits the request successfully"
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

When /^the user submits the following campaign request:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  visit '/'

  click_on "Campaign"

  assert page.has_content?("Request GDS support for a campaign")

  fill_in "Campaign title", :with => @request_details["Campaign title"]
  fill_in "ERG reference number", :with => @request_details["ERG ref number"]
  fill_in "Start date", :with => @request_details["Start date"]
  fill_in "Campaign description", :with => @request_details["Description"]
  fill_in "Group or company affiliated with this campaign", :with => @request_details["Affiliated group"]
  fill_in "URL with more information", :with => @request_details["Info URL"]

  fill_in "Additional comments", :with => @request_details["Additional comments"]

  step "the user submits the request successfully"
end

When /^the user submits the following analytics request:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  visit '/'

  click_on "Analytics"

  assert page.has_content?("Request analytics reports from GDS")

  within "#request-context" do
    choose @request_details["Context"]
  end

  fill_in "From", :with => @request_details["From"]
  fill_in "To", :with => @request_details["To"]

  fill_in "Which page(s) or section(s) on GOV.UK do you want data for? (Please provide URLs and, if possible or relevant, Need IDs)",
    with: @request_details["Pages/sections/URLs"]

  fill_in "How will you use the report and what decisions will it help you make?",
    with: @request_details["What's it for"]

  fill_in "Beyond the basic report, what other information are you interested in?",
    with: @request_details["More detailed analysis"]

  within "#frequency" do
    choose @request_details["Frequency"]
  end

  within "#format" do
    choose @request_details["Format"]
  end

  step "the user submits the request successfully"
end

When /^the user submits the following technical fault report:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  visit '/'

  click_on "Report a technical fault"

  assert page.has_content?("Report a technical fault to GDS")

  within "#technical-fault-context" do
    choose @request_details["Location of fault"]
  end

  fill_in "How much is it affecting? (the whole thing, a specific feature or specific URLs)",
    with: @request_details["What is broken"]

  fill_in "What were you trying to do?",
    with: @request_details["User's actions"]

  fill_in "What happened?",
    with: @request_details["What happened"]

  fill_in "What should have happened?",
    with: @request_details["What should have happened"]
  
  step "the user submits the request successfully"
end
