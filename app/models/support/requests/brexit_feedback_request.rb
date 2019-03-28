require 'browser'
require 'time'

module Support
  module Requests
    class BrexitFeedbackRequest < Request
      attr_accessor :formatted_results
      attr_reader :from_date, :to_date
      def initialize(from_date, to_date, slugs)
        @from_date = from_date
        @to_date = to_date
        @brexit_slugs = slugs
        @support_api = support_api
        @first_page = get_first_page
        @formatted_results = format_results(@first_page).reject do |res|
          is_brexity?(res["path"]) == false
        end
        get_subsequent_pages
      end

      def support_api
        GdsApi::SupportApi.new(
          Plek.new.find("support-api"),
          bearer_token: ENV['SUPPORT_API_BEARER_TOKEN'],
          timeout: 30,
        )
      end

      def get_first_page
        @support_api.problem_reports(from_date: @from_date, to_date: @to_date).to_hash
      end

      def get_subsequent_pages
        page = 2
        until page >= @first_page["pages"] + 1 do
          results = @support_api.problem_reports(from_date: @from_date, to_date: @to_date, page: page).to_hash
          @formatted_results += format_results(results)
          page += 1
        end
      end

      def format_results(result_hash)
        return_array = []
        result_hash["results"].each do |result|
          next unless is_brexity?(result["path"])

          hash = {
            "creation date": "",
            "path": "",
            "what doing?": "",
            "what wrong": "",
            "browser": "",
            "browser version": "",
            "browser platform": "",
            "user agent": "",
            "referrer": "",
          }
          hash["user agent"] = result["user_agent"]
          browser = Browser.new(result["user_agent"], accept_language: "en-us")
          hash["browser platform"] = browser.platform
          hash["browser"] = browser.name
          hash["browser version"] = browser.version
          hash["what doing?"] = result["what_doing"]
          hash["what wrong"] = result["what_wrong"]
          hash["referrer"] = result["referrer"]
          hash["path"] = result["path"]
          hash["creation date"] = Time.parse(result["created_at"]).to_s
          return_array << hash
        end
        return_array
      end

      def is_brexity?(url)
        @brexit_slugs.filter { |slug| url.start_with?(slug) }.empty? ? false : true
      end
    end
  end
end
