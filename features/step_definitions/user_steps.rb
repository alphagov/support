Given /^the following user has SSO access:$/ do |user_details|
  user_details = user_details.hashes.first

  user = FactoryGirl.create(:user_who_can_access_everything, name: user_details["Name"], email: user_details["Email"])

  login_as user
end
