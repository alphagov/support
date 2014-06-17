require "warden/test/helpers"

module GdsSsoHelpers
  def login_as(user)
    GDS::SSO.test_user = user
  end
end

RSpec.configuration.include GdsSsoHelpers, type: :feature
