require 'test/unit'
require 'shoulda/context'
require 'technical_fault_report_zendesk_ticket'
require 'ostruct'

class TechnicalFaultReportZendeskTicketTest < Test::Unit::TestCase
  def ticket_with(opts)
    defaults = { fault_context: stub_everything("component") }
    TechnicalFaultReportZendeskTicket.new(stub_everything("request", defaults.merge(opts)))
  end

  should "add a specific tag based on the problem component" do
    tags_on_ticket = ticket_with(fault_context: stub("component", name: "abc")).tags
    assert_includes tags_on_ticket, "fault_with_abc"
  end

  context "a inside government-related report" do
    should "be tagged with inside_government if the fault is in an Inside Government component" do
      tags_on_ticket = ticket_with(inside_government_related?: true).tags
      assert_includes tags_on_ticket, "technical_fault"
      assert_includes tags_on_ticket, "inside_government"
    end
  end
end