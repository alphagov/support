require "support/requests/with_time_constraint"

module Support
  module Requests
    class ContentChangeRequest < Request
      include WithTimeConstraint

      attr_accessor :title, :details_of_change, :url, :related_urls
      validates_presence_of :details_of_change

      def initialize(attrs = {})
        self.time_constraint = TimeConstraint.new

        super
      end

      def self.label
        "Content changes and new content requests"
      end

      def self.description
        "Request changes to GOV.UK content managed by GDS content designers"
      end
    end
  end
end
