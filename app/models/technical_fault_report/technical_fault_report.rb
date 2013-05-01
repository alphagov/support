require 'shared/request'

class TechnicalFaultReport < Request
  attr_accessor :fault_context
  validates_presence_of :fault_context
  validate do |report|
    if report.fault_context and not report.fault_context.valid?
      errors[:base] << "The source of the fault is not set."
    end
  end

  def fault_context_attributes=(attr)
    self.fault_context = UserFacingComponent.new(attr)
  end

  def inside_government_related?
    fault_context and fault_context.inside_government_related?
  end

  def self.label
    "Report a technical fault"
  end
end