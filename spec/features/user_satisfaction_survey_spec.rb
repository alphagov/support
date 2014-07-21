require 'rails_helper'

feature "User satisfaction survey submissions" do
  # In order to fix and improve my service (that's linked on GOV.UK)
  # As a service manager
  # I want to record and view bugs, gripes and improvement suggestions submitted by the service users

  background do
    login_as create(:user, permissions: ['api_users', 'feedex'])
    the_date_is("2013-02-28")
  end

  scenario "submission with comment" do
    user_submits_satisfaction_survey_on_done_page(
      slug: "done/find-court-tribunal",
      url: "https://www.gov.uk/done/find-court-tribunal",
      service_satisfaction_rating: 3,
      improvement_comments: "Make service less 'meh'",
      user_agent: "Safari",
      javascript_enabled: true,
    )

    explore_anonymous_feedback_with(url: "https://www.gov.uk/done/find-court-tribunal")

    expect(feedex_results).to eq([
      {
        "creation date" => "28.02.2013",
        "feedback" => "rating: 3 comment: Make service less 'meh'",
        "full path" => "/done/find-court-tribunal",
        "user came from" => "–"
      }
    ])
  end

  scenario "submission without a comment" do
    user_submits_satisfaction_survey_on_done_page(
      slug: "done/apply-carers-allowance",
      url: "https://www.gov.uk/done/apply-carers-allowance",
      service_satisfaction_rating: 3,
      improvement_comments: nil,
      javascript_enabled: true,
    )

    explore_anonymous_feedback_with(url: "https://www.gov.uk/done/apply-carers-allowance")

    expect(feedex_results.first["feedback"]).to eq("rating: 3")
  end

  private
  def the_date_is(date_string)
    Timecop.travel Date.parse(date_string)
  end

  def user_submits_satisfaction_survey_on_done_page(options)
    post_json '/anonymous_feedback/service_feedback', { "service_feedback" => options }

    assert_equal 201, last_response.status, "Request not successful, request: #{last_request.body.read}\nresponse: #{last_response.body}"
  end
end
