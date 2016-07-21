require 'support/gds/needed_report'
require 'support/requests/request'

module Support
  module Requests
    class AnalyticsRequest < Request
      attr_accessor :needed_report, :justification_for_needing_report

      validates_presence_of :needed_report, :justification_for_needing_report

      def needed_report_attributes=(attr)
        self.needed_report = Support::GDS::NeededReport.new(attr)
      end

      def self.label
        "Analytics access, reports and help"
      end

      def self.description
        "Request access to Google Analytics or help with analytics or reports"
      end
    end
  end
end
