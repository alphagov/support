require 'support/requests/request'

module Support
  module Requests
    class ErtpProblemReport < Request
      attr_accessor :control_center_ticket_number, :control_center_ticket_number,
                    :local_authority_impacted, :are_multiple_local_authorities_impacted,
                    :description, :incident_stage, :investigation, :additional

      validates_presence_of :control_center_ticket_number, :control_center_ticket_number,
                            :local_authority_impacted, :description, :incident_stage
      validates :are_multiple_local_authorities_impacted, inclusion: { in: ["1", "0"] }

      def formatted_are_multiple_local_authorities_impacted
        self.are_multiple_local_authorities_impacted == "1" ? "yes" : "no"
      end

      def self.label
        "Report an ERTP problem"
      end
    end
  end
end
