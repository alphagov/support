require "rails_helper"

module Zendesk
  module Ticket
    describe TechnicalFaultReportTicket do
      def ticket_with_fault_context(opts)
        TechnicalFaultReportTicket.new(
          Support::Requests::TechnicalFaultReport.new(fault_context: double(opts)),
        )
      end

      subject { ticket_with_fault_context(id: "abc") }
      its(:tags) { should include("fault_with_abc", "technical_fault") }
    end
  end
end
