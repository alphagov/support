require 'browser'
require 'time'

module Support
  module Requests
    class BrexitFeedbackRequest < Request
      attr_reader :from_date, :to_date, :brexity_results
      def initialize(from_date, to_date, slugs)
        @from_date = from_date
        @to_date = to_date
        @brexit_slugs = slugs
        @support_api ||= GdsApi::SupportApi.new(
          Plek.new.find("support-api"),
          bearer_token: ENV['SUPPORT_API_BEARER_TOKEN'],
          timeout: 30,
        )
        @first_page = get_first_page
        @brexity_results = @first_page["results"].reject do |res|
          is_brexity?(res["path"]) == false
        end
        get_subsequent_pages
      end

      def get_first_page
        @support_api.problem_reports(from_date: @from_date, to_date: @to_date).to_hash
      end

      def get_subsequent_pages
        page = 2
        until page >= @first_page["pages"] + 1 do
          response = @support_api.problem_reports(from_date: @from_date, to_date: @to_date, page: page).to_hash
          @brexity_results += response["results"].reject do |res|
            is_brexity?(res["path"]) == false
          end
          page += 1
        end
      end

      def is_brexity?(url)
        @brexit_slugs.filter { |slug| url.start_with?(slug) }.empty? ? false : true
      end
    end
  end
end
