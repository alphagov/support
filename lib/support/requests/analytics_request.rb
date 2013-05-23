require 'shared/request'
require 'shared/with_request_context'
require 'support/requests/needed_report'

module Support
  module Requests
    class AnalyticsRequest < Request
      include WithRequestContext

      attr_accessor :needed_report, :justification_for_needing_report

      validates_presence_of :needed_report, :justification_for_needing_report

      def needed_report_attributes=(attr)
        self.needed_report = NeededReport.new(attr)
      end

      def self.label
        "Analytics"
      end
    end
  end
end