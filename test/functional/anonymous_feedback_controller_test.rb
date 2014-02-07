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

  context "valid input, problem reports" do
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
      should "return the results for problem" do
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

  context "valid input, service feedback" do
    setup do
      login_as_stub_user

      @time = Time.now
      result = Support::Requests::Anonymous::ServiceFeedback.new(
        slug: "apply-carers-allowance",
        details: "It's great",
        service_satisfaction_rating: 5,
        url: "https://www.gov.uk/done/apply-carers-allowance"
      )
      result.created_at = @time

      Support::Requests::Anonymous::AnonymousContact.expects(:find_all_starting_with_path).with("/done/apply-carers-allowance").returns([result])
    end

    context "HTML representation" do
      should "render the results" do
        get :index, path: "/done/apply-carers-allowance"

        assert_response :success          
      end
    end

    context "JSON" do
      should "return the results for problem" do
        get :index, { "path" => "/done/apply-carers-allowance", "format" => "json" }
        
        assert_response :success

        results = JSON.parse(response.body)
        assert_equal 1, results.size
        result = results.first
        assert_equal "apply-carers-allowance", result["slug"]
        assert_equal "It's great", result["details"]
        assert_equal "https://www.gov.uk/done/apply-carers-allowance", result["url"]
        assert_equal 5, result["service_satisfaction_rating"]
        refute result["created_at"].nil?
      end
    end
  end
end
