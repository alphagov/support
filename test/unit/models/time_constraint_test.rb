require 'test_helper'

class TimeConstraintTest < Test::Unit::TestCase
  def self.as_str(date)
    date.strftime("%d-%m-%Y")
  end

  def as_str(date)
    TimeConstraintTest.as_str(date)
  end

  should_not allow_value("xxx").for(:needed_by_date)

  should allow_value(as_str(Date.tomorrow)).for(:needed_by_date)
  should allow_value(as_str(Date.today)).for(:needed_by_date)
  should_not allow_value(as_str(Date.yesterday)).for(:needed_by_date)

  should_not allow_value("xxx").for(:not_before_date)
  
  should allow_value(as_str(Date.tomorrow)).for(:not_before_date)
  should allow_value(as_str(Date.today)).for(:not_before_date)
  should_not allow_value(as_str(Date.yesterday)).for(:not_before_date)

  should "allow the 'not before' and 'needed by' dates to be blank" do
    constraint = TimeConstraint.new(:not_before_date => "", :needed_by_date  => "")
    assert constraint.valid?
  end

  should "not allow the 'not before' date to be set after the 'needed by' date" do
    constraint = TimeConstraint.new(:not_before_date => as_str(Date.tomorrow + 1.day), 
                                    :needed_by_date  => as_str(Date.tomorrow))
    assert !constraint.valid?
    assert constraint.errors[:not_before_date].size > 0
  end

  should "allow a blank not_before_date if the needed_by_date is set" do
    assert TimeConstraint.new(:needed_by_date => as_str(Date.tomorrow)).valid?
  end
end