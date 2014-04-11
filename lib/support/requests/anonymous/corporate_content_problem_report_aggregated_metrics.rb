require 'date'
require_relative "problem_report"

module Support
  module Requests
    module Anonymous
      class FeedbackCounts
        def initialize(first_day_of_period, period_in_question)
          @first_day_of_period = first_day_of_period
          @period_in_question = period_in_question
        end

        def to_a
          counts = feedback_counts
          absolute_count = feedback_counts.values.inject(:+)
          feedback_counts.map do |page_owner, count|
            {
              "_id" => feedback_count_id_for(page_owner),
              "_timestamp" => @first_day_of_period.to_time.iso8601,
              "period" => "month",
              "organisation_acronym" => page_owner,
              "comment_count" => count,
              "total_gov_uk_dept_and_policy_comment_count" => absolute_count
            }
          end
        end

        private
        def feedback_counts
          ProblemReport.
            only_actionable.
            with_known_page_owner.
            where(created_at: @period_in_question).
            order("page_owner asc").
            count(group: :page_owner)
        end

        def feedback_count_id_for(page_owner)
          "#{@first_day_of_period.strftime("%Y%m")}_#{page_owner}"
        end
      end

      class TopUrls
        NUMBER_OF_URLS_PER_ORG = 5

        def initialize(first_day_of_period, period_in_question)
          @first_day_of_period = first_day_of_period
          @period_in_question = period_in_question
        end

        def to_a
          top_urls = distinct_org_acronyms.inject([]) do |list, org_acronym|
            list + top_urls_for(org_acronym).zip(1..NUMBER_OF_URLS_PER_ORG)
          end
          top_urls.map do |top_url, rank|
            {
              "_id" => top_url_id_for(top_url.page_owner, rank),
              "_timestamp" => @first_day_of_period.to_time.iso8601,
              "period" => "month",
              "organisation_acronym" => top_url.page_owner,
              "comment_count" => top_url.number_of_urls,
              "url" => top_url.url
            }
          end
        end

        private
        def top_urls_for(org_acronym)
          ProblemReport.
            only_actionable.
            where(created_at: @period_in_question).
            where(page_owner: org_acronym).
            select("page_owner, url, count(*) as number_of_urls").
            group(:url).
            order("number_of_urls desc, url asc").
            limit(NUMBER_OF_URLS_PER_ORG)
        end

        def distinct_org_acronyms
          ProblemReport.
            only_actionable.
            with_known_page_owner.
            order("page_owner asc").
            select(:page_owner).
            uniq.
            map(&:page_owner)
        end

        def top_url_id_for(page_owner, rank)
          "#{@first_day_of_period.strftime("%Y%m")}_#{page_owner}_#{rank}"
        end
      end

      class CorporateContentProblemReportAggregatedMetrics
        def initialize(year, month)
          @year = year
          @month = month
        end

        def to_h
          {
            "feedback_counts" => FeedbackCounts.new(first_day_of_period, period_in_question).to_a,
            "top_urls" => TopUrls.new(first_day_of_period, period_in_question).to_a
          }
        end

        def period_in_question
          first_day_of_period.beginning_of_day..first_day_of_period.end_of_month.end_of_day
        end

        def first_day_of_period
          Date.new(@year, @month, 1)
        end
      end
    end
  end
end
