module Support
  module Requests
    class GeneralRequest < Request
      attr_accessor :title, :url, :details, :user_agent

      validates_presence_of :details

      def self.label
        "General"
      end

      def self.description
        "Report a problem, request GDS support, or make a suggestion"
      end
    end
  end
end
