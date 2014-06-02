require "test_helper"
require 'json'

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
      assert_select 'nav a', content: "John"
    end

    should "show have a link to log out" do
      assert_select "a[href=/auth/gds/sign_out]", html: "Sign out"
    end

    should "list links to accessibile form sections" do
      assert_select '#section-links a[href="/general_request/new"]'
    end

    should "not list links to inaccessible form sections" do
      @user.stubs(:can?).returns(false)

      get :landing

      assert_select '#section-links a[href="/general_request/new"]', false
    end
  end

  context "GET /_status" do
    should "be accessible without SSO" do
      logout
      @request.env['HTTP_ACCEPT'] = 'application/json'

      get :queue_status

      assert_response :success
    end

    should "return the status of the queues" do
      Sidekiq::Stats.expects(:new).returns(stub("stats", queues: [["queue_a", 3], ["queue_b", 5]]))
      @request.env['HTTP_ACCEPT'] = 'application/json'

      get :queue_status

      actual_response = JSON.parse(@response.body)
      expected_response = {
        "queues" => {
          "queue_a" => { "jobs" => 3 },
          "queue_b" => { "jobs" => 5 }
        }
      }

      assert_equal expected_response, actual_response
    end
  end
end
