require "test_helper"

class SupportControllerTest < ActionController::TestCase
  context "GET landing" do
    should "render the homepage" do
      get :landing
      assert_select "h1", /Welcome to GOV.UK Support/i
    end
  end
end
