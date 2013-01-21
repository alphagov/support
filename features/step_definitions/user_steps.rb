Given /^the following user has SSO access:$/ do |user_details|
  user = stub_everything('user', :name => "user", :has_permission? => true)
  @user_details = user_details.hashes.first

  login_as user
end