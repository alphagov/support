GDS::SSO.config do |config|
  config.user_model   = 'User'
  config.oauth_id     = ENV['OAUTH_ID'] || 'abcdefghjasndjkasndsupport'
  config.oauth_secret = ENV['OAUTH_SECRET'] || 'secret'
  config.oauth_root_url = Plek.current.find("signon")
end

if Rails.env == "development" && ENV['GDS_SSO_STRATEGY'] != 'real'
  GDS::SSO.test_user = User.upsert!(
    "uid" => 'dummy-user',
    "name" => 'Ms Example',
    "email" => 'example@example.com',
    "permissions" => ['single_points_of_contact', 'api_users', 'feedex_exporters']
  )
end
