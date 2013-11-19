require 'test_helper'
require 'support/requests/anonymous/service_feedback'

module Support
  module Requests
    module Anonymous
      class ServiceFeedbackTest < Test::Unit::TestCase
        should validate_presence_of(:service_satisfaction_rating)
        should allow_value(nil).for(:details)
        should validate_presence_of(:slug)

        should ensure_inclusion_of(:service_satisfaction_rating).in_range(1..5)
      end
    end
  end
end
