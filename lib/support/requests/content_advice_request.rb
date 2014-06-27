require 'support/requests/request'

module Support
  module Requests
    class ContentAdviceRequest < Request
      attr_accessor :title, :nature_of_request, :nature_of_request_details, :details

      validates_presence_of :nature_of_request
      validates_presence_of :details
      validates :nature_of_request, inclusion: {
        in: %w(initial_guidance formal_response other),
        message: "%{value} is not valid option"
      }

      validates_presence_of :nature_of_request_details,
        if: Proc.new { |r| r.nature_of_request == 'other' }

      def nature_of_request_options
        [
          ["Initial guidance from GOV.UK on content you are working on", "initial_guidance"],
          ["A formal response that you would like to pass onto other teams in your department or organisation", "formal_response"],
          ["Other - please give information", "other"],
        ]
      end

      def formatted_nature_of_request
        Hash[nature_of_request_options].key(nature_of_request)
      end

      def self.label
        "Content advice"
      end

      def self.description
        "Ask for advice and guidance on Departments and Policy content"
      end
    end
  end
end
