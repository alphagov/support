require 'date'
require_relative "service_feedback"

module Support
  module Requests
    module Anonymous
      class ServiceFeedbackAggregatedMetrics
        def initialize(day, slug)
          @day = day
          @slug = slug
        end

        def to_h
          metadata.merge(aggregates)
        end

        private
        def aggregates
          by_rating = filter_by_day_and_slug.aggregates_by_rating

          results_array = by_rating.map {|rating, count| ["rating_#{rating}", count] }.flatten +
                          [ "comments", filter_by_day_and_slug.with_comments_count ] +
                          [ "total", by_rating.values.inject(:+)]

          Hash[*results_array]
        end

        def metadata
          {
            "_id" => metric_id,
            "_timestamp" => start_timestamp,
            "period" => "day",
            "slug" => @slug
          }
        end

        def metric_id
          "#{@day.strftime("%Y%m%d")}_#{@slug}"
        end

        def start_timestamp
          @day.to_time.iso8601
        end

        def filter_by_day_and_slug
          ServiceFeedback.where(slug: @slug, created_at: time_interval)
        end

        def time_interval
          (@day.to_time...@day.to_time + 1.day)
        end
      end
    end
  end
end
