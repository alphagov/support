require 'test_helper'
require 'support/requests/analytics_request'

module Support
  module Requests
    class AnalyticsRequestTest < Test::Unit::TestCase
      should validate_presence_of(:requester)
      should validate_presence_of(:request_context)

      should validate_presence_of(:needed_report)
      should validate_presence_of(:justification_for_needing_report)
    end
  end
end