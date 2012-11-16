When /^the user submits the following general request:$/ do |request_details_table|
  request_details = request_details_table.hashes.first

  visit '/'

  click_on "General"

  assert page.has_content?("Report a problem")

  fill_in "Name", :with => @user_details["Name"]
  fill_in "Email", :with => @user_details["Email"]
  fill_in "Job title", :with => @user_details["Job title"]
  select @user_details["Organisation"], :from => 'Organisation'

  fill_in "Details", :with => request_details['Details']
  fill_in "URL (if applicable)", :with => request_details['URL']

  click_on "Submit"
end
