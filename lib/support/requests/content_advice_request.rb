require 'support/requests/request'
require 'support/requests/with_time_constraint'
require 'active_support/core_ext'

module Support
  module Requests
    class ContentAdviceRequest < Request
      include WithTimeConstraint

      attr_accessor :title, :nature_of_request, :nature_of_request_details,
                    :details, :urls, :contact_number

      validates_presence_of :nature_of_request
      validates_presence_of :details
      validates :nature_of_request, inclusion: {
        in: %w(initial_guidance formal_response other),
        message: "%{value} is not a valid option"
      }

      validates_presence_of :nature_of_request_details,
        if: Proc.new { |r| r.nature_of_request == 'other' }

      def initialize(attrs = {})
        self.time_constraint = TimeConstraint.new

        super
      end

      def nature_of_request_options
        [
          ["Initial guidance from GOV.UK on content you are working on", "initial_guidance"],
          ["A formal response that you would like to pass onto other teams in your department or organisation", "formal_response"],
          ["Other - please give information", "other"],
        ]
      end

      def formatted_nature_of_request
        if nature_of_request == "other"
          nature_of_request_details
        else
          Hash[nature_of_request_options].key(nature_of_request)
        end
      end

      def self.label
        "Content advice and help"
      end

      def self.description
        "Ask for help or advice on any content problems"
      end
    end
  end
end
