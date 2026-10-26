require "user"

# gds-sso's mock strategy signs in as GDS::SSO.test_user, falling back to
# User.first - which this app's Redis-backed User doesn't have. So whenever
# that strategy is used, sign in as a dummy user. Specs set their own test user.
if GDS::SSO::Config.use_mock_strategies? && !Rails.env.test?
  GDS::SSO.test_user = User.upsert!(
    "uid" => "dummy-user",
    "name" => "Ms Example",
    "email" => "example@example.com",
    "permissions" => %w[single_points_of_contact feedex_exporters],
  )
end
