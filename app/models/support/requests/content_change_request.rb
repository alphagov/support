require "support/requests/with_time_constraint"

module Support
  module Requests
    class ContentChangeRequest < Request
      include WithTimeConstraint

      attr_accessor :title, :reason_for_change, :subject_area, :details_of_change, :why_is_change_needed, :url, :related_urls

      validates :details_of_change, presence: true

      def initialize(attrs = {})
        self.time_constraint = TimeConstraint.new

        super
      end

      def self.label
        "Request a content change or new content on GOV.UK"
      end

      def self.description
        "Request changes to GOV.UK content managed by GDS content designers"
      end
    end
  end
end
