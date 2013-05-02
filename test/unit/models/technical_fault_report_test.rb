require 'test_helper'

class TechnicalFaultReportTest < Test::Unit::TestCase
  should validate_presence_of(:requester)
  should validate_presence_of(:fault_context)
  should validate_presence_of(:fault_specifics)
  should validate_presence_of(:actions_leading_to_problem)
  should validate_presence_of(:what_happened)
  should validate_presence_of(:what_should_have_happened)

  should "be Inside Government-related if the fault context is" do
    assert TechnicalFaultReport.new(fault_context: stub("component", inside_government_related?: true)).inside_government_related?
    refute TechnicalFaultReport.new(fault_context: stub("component", inside_government_related?: false)).inside_government_related?
  end
end