require "rails_helper"

module Zendesk
  module Ticket
    describe TechnicalFaultReportTicket do
      def ticket_with_fault_context(fault_context)
        TechnicalFaultReportTicket.new(
          Support::Requests::TechnicalFaultReport.new(fault_context:),
        )
      end

      subject { ticket_with_fault_context("abc") }
      its(:tags) { should include("fault_with_abc", "technical_fault") }
    end
  end
end
