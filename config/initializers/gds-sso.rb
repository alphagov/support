GDS::SSO.config do |config|
  config.user_model   = 'ReadOnlyUser'
  config.oauth_id     = 'abcdefghjasndjkasndsupport'
  config.oauth_secret = 'secret'
  config.default_scope = "Support"
  config.oauth_root_url = Plek.current.find("signon")
end
