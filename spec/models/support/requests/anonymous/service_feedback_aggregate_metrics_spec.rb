require 'rails_helper'

module Support
  module Requests
    module Anonymous
      describe ServiceFeedbackAggregatedMetrics do
        def create_feedback(options)
          defaults = {
            slug: "a",
            javascript_enabled: true,
            is_actionable: true,
            service_satisfaction_rating: 3
          }
          f = ServiceFeedback.create!(defaults.merge(options))
          f.update_attribute(:created_at, options[:created_at])
        end

        before do
          create_feedback(service_satisfaction_rating: 1, slug: "abcde", created_at: Date.new(2013,2,10))
          create_feedback(service_satisfaction_rating: 3, slug: "apply-carers-allowance", created_at: Date.new(2013,2,10))
          create_feedback(service_satisfaction_rating: 2, details: "abcde", slug: "apply-carers-allowance", created_at: Date.new(2013,2,10))
        end

        let(:metrics) { ServiceFeedbackAggregatedMetrics.new(Date.new(2013,2,10), "apply-carers-allowance").to_h }

        context "metadata" do
          it "generates an id based on the slug and date" do
            expect(metrics["_id"]).to eq("20130210_apply-carers-allowance")
          end

          it "sets the period to a day" do
            expect(metrics["period"]).to eq("day")
          end

          it "sets the start time correctly" do
            expect(metrics["_timestamp"]).to eq("2013-02-10T00:00:00+00:00")
          end

          it "contains the slug" do
            expect(metrics["slug"]).to eq("apply-carers-allowance")
          end
        end

        context "aggregated metrics" do
          it "includes rating summaries" do
            expect(metrics).to include(
              "rating_1" => 0,
              "rating_2" => 1,
              "rating_3" => 1,
              "rating_4" => 0,
              "rating_5" => 0,
              "total"    => 2,
              "comments" => 1
            )
          end

          it "doesn't include non-actionable comments, such as spam or dupes" do
            ServiceFeedback.delete_all

            create_feedback(
              is_actionable: false,
              reason_why_not_actionable: "abc",
              slug: "apply-carers-allowance",
              created_at: Date.new(2013,2,10)
            )
            stats = ServiceFeedbackAggregatedMetrics.new(Date.new(2013,2,10), "apply-carers-allowance").to_h

            expect(stats["total"]).to eq(0)
          end
        end
      end
    end
  end
end
