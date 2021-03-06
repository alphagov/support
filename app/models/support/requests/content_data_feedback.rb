require "active_support/core_ext"

module Support
  module Requests
    class ContentDataFeedback < Request
      attr_accessor :feedback_type, :feedback_details, :impact_on_work

      OPTIONS = {
        "accessibility or usability" => "accessibility or usability",
        "working unexpectedly" => "something working differently than you expected",
        "helpful feature" => "a feature that would help you with your work",
        "helpful metric" => "a metric that would help you with your work",
        "data looking wrong" => "the data looking wrong",
        "other" => "something else",
      }.freeze

      validates :feedback_type, :feedback_details, presence: true
      validates :feedback_type, inclusion: { in: OPTIONS.keys }

      def self.label
        "Give feedback on Content Data (Beta)"
      end

      def self.description
        "Suggest changes to the data tool."
      end

      def feedback_type_options
        OPTIONS.map { |key, value| [value, key] }
      end
    end
  end
end
