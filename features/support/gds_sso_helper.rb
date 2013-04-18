require "warden/test/helpers"
require_relative "../../test/stub_user"

module GdsSsoHelper
  def login_as(user)
    GDS::SSO.test_user = user
  end
end

World(GdsSsoHelper)