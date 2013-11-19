require "test_helper"

module AnonymousFeedback
  module ProblemReports
    class ExploreControllerTest < ActionController::TestCase
      context "new request" do
        should "return show the new form again for invalid requests" do
          post :create, { support_requests_anonymous_explore: { by_url: "abc" } }

          assert_response 400
        end

        should "redirect to the problem reports index page for successful requests" do
          post :create, { support_requests_anonymous_explore: { by_url: "https://www.gov.uk/tax-disc" } }
          
          assert_redirected_to "/anonymous_feedback/problem_reports?path=%2Ftax-disc"
        end
      end
    end
  end
end
