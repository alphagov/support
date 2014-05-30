require 'support/requests/request'
require 'support/requests/with_time_constraint'
require 'support/gds/with_request_context'

module Support
  module Requests
    class ContentChangeRequest < Request
      include WithTimeConstraint
      include Support::GDS::WithRequestContext

      attr_accessor :title, :details_of_change, :url, :related_urls
      validates_presence_of :details_of_change

      def initialize(attrs = {})
        self.time_constraint = TimeConstraint.new

        super
      end

      def self.label
        "Content change"
      end

      def self.description
        "Request a change to existing GOV.UK content"
      end
    end
  end
end
