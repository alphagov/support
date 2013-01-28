require 'shared/time_constraint'

module WithTimeConstraint
  def self.included(base)
    base.validate do |request|
      if request.time_constraint and not request.time_constraint.valid?
        errors[:base] << "Time constraint details are invalid."
      end
    end
  end
  attr_accessor :time_constraint

  def time_constraint_attributes=(attr)
    self.time_constraint = TimeConstraint.new(attr)
  end
end