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

        should allow_value("https://www.gov.uk/something").for(:url)
        should allow_value(nil).for(:url)
        should allow_value("http://" + ("a" * 2040)).for(:url)
        should_not allow_value("http://" + ("a" * 2050)).for(:url)
        should_not allow_value("http://bla.example.org:9292/méh/fào?bar").for(:url)
      end
    end
  end
end
