require 'date'
require_relative "problem_report"

module Support
  module Requests
    module Anonymous
      class CorporateContentProblemReportAggregatedMetrics
        def initialize(year, month)
          @year = year
          @month = month
        end

        def to_h
          { "feedback_counts" => feedback_count_entries }
        end

        private
        def feedback_count_entries
          counts = feedback_counts
          absolute_count = feedback_counts.values.inject(:+)
          feedback_counts.map do |page_owner, count|
            {
              "_id" => feedback_count_id_for(page_owner),
              "_timestamp" => first_day_of_period.to_time.iso8601,
              "period" => "month",
              "organisation_acronym" => page_owner,
              "comment_count" => count,
              "total_gov_uk_dept_and_policy_comment_count" => absolute_count
            }
          end
        end

        def feedback_counts
          ProblemReport.
            only_actionable.
            with_known_page_owner.
            where(created_at: period_in_question).
            order("page_owner asc").
            count(group: :page_owner)
        end

        def period_in_question
          first_day_of_period.beginning_of_day..first_day_of_period.end_of_month.end_of_day
        end

        def first_day_of_period
          Date.new(@year, @month, 1)
        end

        def feedback_count_id_for(page_owner)
          "#{first_day_of_period.strftime("%Y%m")}_#{page_owner}"
        end
      end
    end
  end
end
