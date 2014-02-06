require 'test_helper'

class RedirectsTest < ActionDispatch::IntegrationTest
  test "the legacy feedex landing page redirects to the current feedex landing page" do
    get '/anonymous_feedback/problem_reports/explore'

    assert_redirected_to '/anonymous_feedback/explore'
  end

  test "old feedex links redirect to new feedex links" do
    get '/anonymous_feedback/problem_reports?path=/vat-rates'

    assert_redirected_to '/anonymous_feedback?path=/vat-rates'
  end
end
