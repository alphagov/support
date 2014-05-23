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
      result = Support::Requests::Anonymous::ProblemReport.create!(
        what_wrong: "A",
        what_doing: "B",
        url: "https://www.gov.uk/tax-disc",
        referrer: "https://www.gov.uk/tax-disc",
        javascript_enabled: true
      )
      result.created_at = @time
      result.save
    end

    context "HTML representation" do
      should "render the results" do
        get :index, path: "/tax-disc"

        assert_response :success
      end

      should "display at most 50 results per page" do
        70.times {
          Support::Requests::Anonymous::ProblemReport.create!(
            what_wrong: "A",
            what_doing: "B",
            url: "https://www.gov.uk/tax-disc",
            javascript_enabled: true
          )
        }

        get :index, path: "/tax-disc"

        assert_equal 50, assigns["feedback"].to_a.size
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
      result = Support::Requests::Anonymous::ServiceFeedback.create!(
        slug: "apply-carers-allowance",
        details: "It's great",
        service_satisfaction_rating: 5,
        url: "https://www.gov.uk/done/apply-carers-allowance",
        javascript_enabled: true
      )
      result.created_at = @time
      result.save
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
