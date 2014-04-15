require 'test_helper'

module Support
  module Requests
    module Anonymous
      class CorporateContentProblemReportAggregatedMetricsTest < Test::Unit::TestCase
        def setup
          { 7 => ["a"], 5 => ["b", "c", "d"], 3 => ["e", "f"], 1 => ["g"] }.each do |count, slugs|
            slugs.each do |slug|
              count.times { create_report(page_owner: "co", created_at: Date.new(2013,2,10), url: "https://www.gov.uk/#{slug}") }
            end
          end

          create_report(page_owner: "dft", created_at: Date.new(2013,2,10), url: "https://www.gov.uk/h")
          create_report(page_owner: "hmrc", created_at: Date.new(2013,2,10), url: "https://www.gov.uk/i")
          create_report(page_owner: "co", created_at: Date.new(2013,1,1), url: "https://www.gov.uk/a")

          @stats = CorporateContentProblemReportAggregatedMetrics.new(2013, 2).to_h
        end

        def teardown
          ProblemReport.delete_all
        end

        def create_report(options)
          defaults = {
            javascript_enabled: true,
            is_actionable: true,
          }
          f = ProblemReport.create!(defaults.merge(options))
          f.update_attribute(:created_at, options[:created_at])
        end

        context "counts" do
          context "metadata" do
            should "generate ids based on the slug and date" do
              ids = @stats["feedback_counts"].map {|entry| entry["_id"] }
              assert_equal [ "201302_co", "201302_dft", "201302_hmrc" ], ids
            end

            should "set the period to a day" do
              periods = @stats["feedback_counts"].map {|entry| entry["period"] }
              assert_equal [ "month" ], periods.uniq
            end

            should "set the start time correctly" do
              timestamps = @stats["feedback_counts"].map {|entry| entry["_timestamp"] }
              assert_equal [ "2013-02-01T00:00:00+00:00" ], timestamps.uniq
            end
          end

          context "aggregated metrics" do
            should "include comment counts, grouped by page owner" do
              counts = @stats["feedback_counts"].map {|entry| [ entry["organisation_acronym"], entry["comment_count"] ] }
              assert_equal [ ["co", 29], ["dft", 1], ["hmrc", 1] ], counts
            end

            should "include the absolute count" do
              absolute_counts = @stats["feedback_counts"].map {|entry| entry["total_gov_uk_dept_and_policy_comment_count"] }
              assert_equal [ 31 ], absolute_counts.uniq
            end
          end
        end

        context "top urls" do
          context "metadata" do
            should "generate ids based on the slug and date" do
              ids = @stats["top_urls"].map {|entry| entry["_id"] }
              expected_ids = (1..5).map {|n| "201302_co_#{n}" } + ["201302_dft_1", "201302_hmrc_1"]
              assert_equal expected_ids, ids
            end

            should "set the period to a day" do
              periods = @stats["top_urls"].map {|entry| entry["period"] }
              assert_equal [ "month" ], periods.uniq
            end

            should "set the start time correctly" do
              timestamps = @stats["top_urls"].map {|entry| entry["_timestamp"] }
              assert_equal [ "2013-02-01T00:00:00+00:00" ], timestamps.uniq
            end
          end

          context "aggregated metrics" do
            should "include urls, comment counts, grouped by page owner" do
              metrics = @stats["top_urls"].map {|entry| [ entry["organisation_acronym"], entry["url"], entry["comment_count"] ] }
              expected_metrics = [
                ["co", "https://www.gov.uk/a", 7],
                ["co", "https://www.gov.uk/b", 5],
                ["co", "https://www.gov.uk/c", 5],
                ["co", "https://www.gov.uk/d", 5],
                ["co", "https://www.gov.uk/e", 3],
                ["dft", "https://www.gov.uk/h", 1],
                ["hmrc", "https://www.gov.uk/i", 1],
              ]
              assert_equal expected_metrics, metrics
            end
          end
        end
      end
    end
  end
end
