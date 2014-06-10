require 'rails_helper'
require 'date'
require 'support/requests/anonymous/service_feedback'

module Support
  module Requests
    module Anonymous
      describe ServiceFeedback do
        it { should validate_presence_of(:service_satisfaction_rating) }
        it { should allow_value(nil).for(:details) }
        it { should validate_presence_of(:slug) }

        it { should ensure_inclusion_of(:service_satisfaction_rating).in_range(1..5) }

        def create_feedback(options)
          ServiceFeedback.create!(slug: options[:slug] || "a",
                                  details: options[:details],
                                  service_satisfaction_rating: options[:rating],
                                  javascript_enabled: true)
        end

        before do
          ServiceFeedback.delete_all

          create_feedback(rating: 1, slug: "a")
          create_feedback(rating: 2, slug: "a", details: "meh")
          create_feedback(rating: 5, slug: "b")
        end

        it "aggregates by rating" do
          expect(ServiceFeedback.aggregates_by_rating).to eq(
            1 => 1,
            2 => 1,
            3 => 0,
            4 => 0,
            5 => 1
          )
        end

        it "aggregates by comment" do
          expect(ServiceFeedback.with_comments_count).to eq(1)
        end

        it "provides a list of available slugs" do
          expect(ServiceFeedback.transaction_slugs).to eq(["a", "b"])
        end
      end
    end
  end
end
