require "test_helper"

class SupportControllerTest < ActionController::TestCase
  setup do
    login_as_stub_user(name: "John")
  end

  context "GET landing" do
    setup do
      get :landing
    end

    should "render the homepage" do
      assert_select "h1", /Welcome to GOV.UK Support/i
    end

    should "show the name of the user who is logged in" do
      assert_select '#logged-in-user a', content: "John"
    end

    should "show have a link to log out" do
      assert_select "a[href=/auth/gds/sign_out]", html: "Sign out"
    end    
  end
end
