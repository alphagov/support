require 'rails_helper'
require 'support/requests/anonymous/duplicate_detector'

module Support
  module Requests
    module Anonymous
      describe DuplicateDetector do
        it "identifies duplicate records" do
          r1 = double("record 1")
          r2 = double("record 2")
          r3 = double("record 3")

          allow_any_instance_of(AnonymousFeedbackComparator).to receive(:same?).with(r1, r2).and_return(false)
          allow_any_instance_of(AnonymousFeedbackComparator).to receive(:same?).with(r1, r3).and_return(true)
          allow_any_instance_of(AnonymousFeedbackComparator).to receive(:same?).with(r2, r3).and_return(false)
          allow_any_instance_of(AnonymousFeedbackComparator).to receive(:created_within_a_short_interval?).and_return(true)

          detector = DuplicateDetector.new

          expect(detector.duplicate?(r1)).to be_falsey
          expect(detector.duplicate?(r2)).to be_falsey
          expect(detector.duplicate?(r3)).to be_truthy
        end

        context "the comparator" do
          it "detects if two identical pieces of feedback are created within a short time of each other" do
            comparator = AnonymousFeedbackComparator.new
            defaults = { "service_satisfaction_rating" => 5, "details" => "it's ace" }

            time = Time.now
            r1 = defaults.merge("created_at" => time)
            r2 = r1.clone
            r3 = defaults.merge("created_at" => time + 4.seconds)
            r4 = defaults.merge("created_at" => time + 8.seconds)

            expect(comparator.same?(r1, r2)).to be_truthy
            expect(comparator.same?(r1, r3)).to be_truthy
            expect(comparator.same?(r1, r4)).to be_falsey
            expect(comparator.same?(r3, r4)).to be_truthy
          end
        end
      end
    end
  end
end
