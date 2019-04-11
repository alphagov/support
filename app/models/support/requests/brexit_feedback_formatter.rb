module Support
  module Requests
    class BrexitFeedbackFormatter < Request
      attr_reader :formatted_results
      def initialize(raw_results)
        @formatted_results = format(raw_results).flatten
      end

      def format(raw_results)
        raw_results.map do |page|
          format_page(page)
        end
      end

      def format_page(result_hash)
        return_array = []
        result_hash["results"].each do |result|
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
          browser = Browser.new(result["user_agent"], accept_language: "en-us")

          hash["user agent"] = result["user_agent"]
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
    end
  end
end
