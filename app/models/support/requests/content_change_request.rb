require "support/requests/with_time_constraint"

module Support
  module Requests
    class ContentChangeRequest < Request
      include WithTimeConstraint

      attr_accessor :title, :reason_for_change, :subject_area, :details_of_change, :url, :related_urls

      validates :details_of_change, presence: true

      def initialize(attrs = {})
        self.time_constraint = TimeConstraint.new

        super
      end

      def self.label
        "Request a content change or new content on mainstream GOV.UK content"
      end

      def self.description
        "Request changes to 'mainstream' GOV.UK content managed by GDS content designers"
      end

      def self.reason_for_change_options
        Zendesk::CustomField.options_for_name("[CR] Reason for the request")
      end

      def self.subject_area_options
        Zendesk::CustomField.options_for_name("[CR] Subject Area")
      end

      delegate :reason_for_change_options, to: :class
      delegate :subject_area_options, to: :class
    end
  end
end
