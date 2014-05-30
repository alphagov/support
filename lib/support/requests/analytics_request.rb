require 'support/gds/with_request_context'
require 'support/gds/needed_report'
require 'support/requests/request'

module Support
  module Requests
    class AnalyticsRequest < Request
      include Support::GDS::WithRequestContext

      attr_accessor :needed_report, :justification_for_needing_report

      validates_presence_of :needed_report, :justification_for_needing_report

      def needed_report_attributes=(attr)
        self.needed_report = Support::GDS::NeededReport.new(attr)
      end

      def self.label
        "Analytics"
      end

      def self.description
        "Request analytics reports from GDS"
      end
    end
  end
end
