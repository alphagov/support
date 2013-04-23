Given /^the following user has SSO access:$/ do |user_details|
  user_details = user_details.hashes.first

  user = stub_everything('user', name: user_details["Name"], email: user_details["Email"], has_permission?: true, can?: true)

  login_as user
end