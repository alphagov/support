require 'tableless_model'

class TimeConstraint < TablelessModel
  attr_accessor :not_before_date, :needed_by_date, :time_constraint_reason

  validates_date :needed_by_date, :allow_nil => true, :allow_blank => true, :on_or_after => :today
  validates_date :not_before_date, :allow_nil => true, :allow_blank => true, :on_or_after => :today
  validates_date :not_before_date, :before => :needed_by_date, :unless => Proc.new { |c| c.needed_by_date.blank? || c.not_before_date.blank? }
end