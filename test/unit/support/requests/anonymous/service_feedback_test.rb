require 'test_helper'
require 'date'
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

        def setup
          ServiceFeedback.delete_all

          create_feedback(rating: 1, slug: "a")
          create_feedback(rating: 2, slug: "a", details: "meh")
          create_feedback(rating: 5, slug: "b")
        end

        should "aggregate by rating" do
          expected = {
            1 => 1,
            2 => 1,
            3 => 0,
            4 => 0,
            5 => 1
          }
          assert_equal expected, ServiceFeedback.aggregates_by_rating
        end

        should "aggregate by comment" do
          assert_equal 1, ServiceFeedback.with_comments_count
        end

        should "provide a list of available slugs" do
          assert_equal ["a", "b"], ServiceFeedback.transaction_slugs
        end

        def create_feedback(options)
          ServiceFeedback.create!(slug: options[:slug] || "a",
                                  details: options[:details],
                                  service_satisfaction_rating: options[:rating],
                                  javascript_enabled: true)
        end
      end
    end
  end
end
