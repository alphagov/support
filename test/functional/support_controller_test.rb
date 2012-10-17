require_relative "../test_helper"

class SupportControllerTest < ActionController::TestCase
  context "GET landing" do
    should "render the homepage" do
      get :landing
      assert_select "h1", /Welcome to GovUK Support/i
    end
  end

  # context "GET amend_content" do
  #   should "render the form" do
  #     get :amend_content
  #     assert_select
  #   end
  # end

  # context "POST amend_content" do
  #   should "" do
  #   end
  # end
end