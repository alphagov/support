require 'test_helper'
require 'time'
require 'json'

class DeduplicationTest < ActionDispatch::IntegrationTest
  def setup
    User.first
  rescue
    User.create!(
      "uid" => 'dummy-user',
      "name" => 'Ms Example',
      "email" => 'example@example.com',
      "permissions" => ['single_points_of_contact', 'feedex', 'api_users']
    )
  end

  test "duplicate service feedback is flagged and removed from results" do
    # create service feedback

    Timecop.travel Time.parse("2013-01-15 12:00:00")

    create_service_feedback_with(
      service_satisfaction_rating: 5,
      details: "this service is great",
      slug: "some-tx",
      url: "https://www.gov.uk/done/some-tx"
    )    

    create_service_feedback_with(
      service_satisfaction_rating: 3,
      details: "this service is meh",
      slug: "some-tx",
      url: "https://www.gov.uk/done/some-tx"
    )

    Timecop.travel Time.parse("2013-01-15 12:00:01")

    create_service_feedback_with(
      service_satisfaction_rating: 3,
      details: "this service is meh",
      slug: "some-tx",
      url: "https://www.gov.uk/done/some-tx"
    )

    get '/anonymous_feedback?path=/done/some-tx', "", {"CONTENT_TYPE" => 'application/json', 'HTTP_ACCEPT' => 'application/json'}

    results = JSON.parse(response.body)
    assert_equal 3, results.size

    # deduplicate
    Timecop.travel Time.parse("2013-01-16 00:30:00")
    DeduplicationWorker.run

    # rerun query, one piece of feedback should now be suppressed
    get '/anonymous_feedback?path=/done/some-tx', "", {"CONTENT_TYPE" => 'application/json', 'HTTP_ACCEPT' => 'application/json'}

    results = JSON.parse(response.body)
    assert_equal 2, results.size
    assert_equal ["this service is great", "this service is meh"], results.map {|r| r["details"]}.sort
  end

  def teardown
    Timecop.return
  end

  def create_service_feedback_with(options)
    defaults = {
      service_satisfaction_rating: 5,
      details: "this service is great",
      javascript_enabled: true,
    }
    Support::Requests::Anonymous::ServiceFeedback.create!(defaults.merge(options))
  end
end
