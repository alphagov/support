require "active_support/core_ext"

module Support
  module Requests
    class ContentPublisherFeedbackRequest < Request
      attr_accessor :feedback_type, :feedback_details, :impact_on_work

      OPTIONS = {
        "accessibility or usability" => "accessibility or usability",
        "working unexpectedly" => "something working differently than you expected",
        "helpful feature" => "a feature that would help you with your work",
        "other" => "something else",
      }.freeze

      validates_presence_of :feedback_type, :feedback_details
      validates :feedback_type, inclusion: { in: OPTIONS.keys }

      def self.label
        "Give feedback on Content Publisher (Beta)"
      end

      def self.description
        "Suggest changes to features within Content Publisher."
      end

      def feedback_type_options
        OPTIONS.map { |key, value| [value, key] }
      end
    end
  end
end
