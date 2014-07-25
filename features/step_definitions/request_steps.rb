When /^the user submits the request successfully$/ do
  click_on "Submit"
  assert page.has_content?("You should receive a confirmation email shortly."), page.html
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
