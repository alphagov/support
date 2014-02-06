require "test_helper"
require 'support/requests/anonymous/problem_report'

class AnonymousFeedbackControllerTest < ActionController::TestCase
  context "invalid input" do
    context "HTML representation" do
      should "redirect to the explore endpoint when no path given" do
        get :index

        assert_redirected_to anonymous_feedback_explore_url
      end
    end

    context "JSON" do
      should "return an error when no path given" do
        get :index, format: :json
        assert_response 400

        expected_result = { "errors" => ["Please set a valid 'path' parameter"] }
        assert_equal expected_result, JSON.parse(response.body) 
      end
    end
  end

  context "valid input" do
    setup do
      login_as_stub_user

      @time = Time.now
      result = Support::Requests::Anonymous::ProblemReport.new(
        what_wrong: "A",
        what_doing: "B",
        url: "https://www.gov.uk/tax-disc",
        referrer: "https://www.gov.uk/tax-disc"
      )
      result.created_at = @time

      Support::Requests::Anonymous::AnonymousContact.expects(:find_all_starting_with_path).with("/tax-disc").returns([result])
    end

    context "HTML representation" do
      should "render the results" do
        get :index, path: "/tax-disc"

        assert_response :success          
      end
    end

    context "JSON" do
      should "return the results" do
        get :index, { "path" => "/tax-disc", "format" => "json" }
        
        assert_response :success

        results = JSON.parse(response.body)
        assert_equal 1, results.size
        result = results.first
        assert_equal "A", result["what_wrong"]
        assert_equal "B", result["what_doing"]
        assert_equal "https://www.gov.uk/tax-disc", result["url"]
        assert_equal "https://www.gov.uk/tax-disc", result["referrer"]
        refute result["created_at"].nil?
      end
    end
  end
end
