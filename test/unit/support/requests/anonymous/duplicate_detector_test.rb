require 'test_helper'
require 'support/requests/anonymous/duplicate_detector'

module Support
  module Requests
    module Anonymous
      class DuplicateDetectorTest < Test::Unit::TestCase
        should "identify duplicate records" do
          r1 = stub("record 1")
          r2 = stub("record 2")
          r3 = stub("record 3")

          AnonymousFeedbackComparator.any_instance.stubs(:same?).with(r1, r2).returns(false)
          AnonymousFeedbackComparator.any_instance.stubs(:same?).with(r1, r3).returns(true)
          AnonymousFeedbackComparator.any_instance.stubs(:same?).with(r2, r3).returns(false)
          AnonymousFeedbackComparator.any_instance.stubs(:created_within_a_short_interval?).returns(true)

          detector = DuplicateDetector.new

          refute detector.duplicate?(r1)
          refute detector.duplicate?(r2)
          assert detector.duplicate?(r3)
        end

        context "the comparator" do
          should "detect if two identical pieces of feedback are created within a short time of each other" do
            comparator = AnonymousFeedbackComparator.new
            defaults = { "service_satisfaction_rating" => 5, "details" => "it's ace" }

            time = Time.now
            r1 = defaults.merge("created_at" => time)
            r2 = r1.clone
            r3 = defaults.merge("created_at" => time + 4.seconds)
            r4 = defaults.merge("created_at" => time + 8.seconds)

            assert comparator.same?(r1, r2)
            assert comparator.same?(r1, r3)
            refute comparator.same?(r1, r4)
            assert comparator.same?(r3, r4)
          end
        end
      end
    end
  end
end
