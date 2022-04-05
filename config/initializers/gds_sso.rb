require "user"

if Rails.env.development? && ENV["GDS_SSO_STRATEGY"] != "real"
  GDS::SSO.test_user = User.upsert!(
    "uid" => "dummy-user",
    "name" => "Ms Example",
    "email" => "example@example.com",
    "permissions" => %w[single_points_of_contact api_users feedex_exporters],
  )
end
