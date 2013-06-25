require 'support/requests/request'

module Support
  module Requests
    class ErtpProblemReport < Request
      attr_accessor :control_center_ticket_number, :control_center_ticket_number,
                    :local_authority_impacted, :are_multiple_local_authorities_impacted,
                    :description, :incident_stage, :investigation, :additional,
                    :ems_supplier, :priority

      validates_presence_of :control_center_ticket_number, :control_center_ticket_number,
                            :local_authority_impacted, :description, :incident_stage,
                            :ems_supplier, :priority
      validates :are_multiple_local_authorities_impacted, inclusion: { in: ["1", "0"] }
      validates :priority, inclusion: { in: ["low", "normal", "high", "urgent"] }

      def formatted_priority
        Hash[priority_options].key(priority)
      end

      def priority_options
        [
          ["1 - urgent", "urgent"],
          ["2 - high", "high"],
          ["3 - normal", "normal"],
          ["4 - low", "low"]
        ]
      end

      def formatted_are_multiple_local_authorities_impacted
        self.are_multiple_local_authorities_impacted == "1" ? "yes" : "no"
      end

      def self.label
        "Report an ERTP problem"
      end
    end
  end
end
