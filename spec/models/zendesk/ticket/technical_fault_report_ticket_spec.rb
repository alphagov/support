require 'spec_helper'
require 'support/requests/technical_fault_report'
require 'zendesk/ticket/technical_fault_report_ticket'

module Zendesk
  module Ticket
    describe TechnicalFaultReportTicket do
      def ticket_with_fault_context(opts)
        TechnicalFaultReportTicket.new(
          Support::Requests::TechnicalFaultReport.new(fault_context: double(opts))
        )
      end

      subject { ticket_with_fault_context(id: "abc", inside_government_related?: false) }
      its(:tags) { should include("fault_with_abc", "technical_fault") }

      context "a inside government-related report" do
        subject { ticket_with_fault_context(inside_government_related?: true, id: "some_component") }
        its(:tags) { should include("inside_government") }
      end
    end
  end
end
