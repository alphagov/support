require 'rails_helper'
require 'support/requests/anonymous/corporate_content_problem_report_aggregated_metrics'

module Support
  module Requests
    module Anonymous
      describe CorporateContentProblemReportAggregatedMetrics do
        def create_report(options)
          defaults = {
            javascript_enabled: true,
            is_actionable: true,
          }
          f = ProblemReport.create!(defaults.merge(options))
          f.update_attribute(:created_at, options[:created_at])
        end

        before do
          { 7 => ["a"], 5 => ["b", "c", "d"], 3 => ["e", "f"], 1 => ["g"] }.each do |count, slugs|
            slugs.each do |slug|
              count.times { create_report(page_owner: "co", created_at: Date.new(2013,2,10), path: "/#{slug}") }
            end
          end

          create_report(page_owner: "dft", created_at: Date.new(2013,2,10), path: "/h")
          create_report(page_owner: "hmrc", created_at: Date.new(2013,2,10), path: "/i")
          create_report(page_owner: "co", created_at: Date.new(2013,1,1), path: "/a")
        end

        after do
          ProblemReport.delete_all
        end

        let(:metrics) { CorporateContentProblemReportAggregatedMetrics.new(2013, 2).to_h }

        context "counts" do
          let(:feedback_counts) { metrics["feedback_counts"] }

          context "metadata" do
            it "generates ids based on the slug and date" do
              ids = feedback_counts.map {|entry| entry["_id"] }
              expect(ids).to eq([ "201302_co", "201302_dft", "201302_hmrc" ])
            end

            it "sets the period to a day" do
              periods = feedback_counts.map {|entry| entry["period"] }
              expect(periods.uniq).to eq([ "month" ])
            end

            it "sets the start time correctly" do
              timestamps = feedback_counts.map {|entry| entry["_timestamp"] }
              expect(timestamps.uniq).to eq([ "2013-02-01T00:00:00+00:00" ])
            end
          end

          context "aggregated metrics" do
            it "includes comment counts, grouped by page owner" do
              counts = feedback_counts.map {|entry| [ entry["organisation_acronym"], entry["comment_count"] ] }
              expect(counts).to eq([ ["co", 29], ["dft", 1], ["hmrc", 1] ])
            end

            it "includes the absolute count" do
              absolute_counts = feedback_counts.map {|entry| entry["total_gov_uk_dept_and_policy_comment_count"] }
              expect(absolute_counts.uniq).to eq([ 31 ])
            end
          end
        end

        context "top urls" do
          let(:top_urls) { metrics["top_urls"] }

          context "metadata" do
            it "generates ids based on the slug and date" do
              ids = top_urls.map {|entry| entry["_id"] }
              expected_ids = (1..5).map {|n| "201302_co_#{n}" } + ["201302_dft_1", "201302_hmrc_1"]
              expect(ids).to eq(expected_ids)
            end

            it "sets the period to a day" do
              periods = top_urls.map {|entry| entry["period"] }
              expect(periods.uniq).to eq([ "month" ])
            end

            it "sets the start time correctly" do
              timestamps = top_urls.map {|entry| entry["_timestamp"] }
              expect(timestamps.uniq).to eq([ "2013-02-01T00:00:00+00:00" ])
            end
          end

          context "aggregated metrics" do
            it "includes urls, comment counts, grouped by page owner" do
              aggregates = top_urls.map {|entry| [ entry["organisation_acronym"], entry["url"], entry["comment_count"] ] }
              expect(aggregates).to eq([
                ["co", "http://www.dev.gov.uk/a", 7],
                ["co", "http://www.dev.gov.uk/b", 5],
                ["co", "http://www.dev.gov.uk/c", 5],
                ["co", "http://www.dev.gov.uk/d", 5],
                ["co", "http://www.dev.gov.uk/e", 3],
                ["dft", "http://www.dev.gov.uk/h", 1],
                ["hmrc", "http://www.dev.gov.uk/i", 1],
              ])
            end
          end
        end
      end
    end
  end
end
