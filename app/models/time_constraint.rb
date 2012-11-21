require 'tableless_model'
require 'date'

class TimeConstraint < TablelessModel
  attr_writer :not_before_date, :needed_by_date
  attr_accessor :time_constraint_reason

  validate :not_before_date_is_a_date,
           :needed_by_date_is_a_date,
           :not_before_date_cannot_be_in_the_past,
           :needed_by_date_cannot_be_in_the_past,
           :not_before_date_cannot_come_after_the_needed_by_date

  def not_before_date
    as_date(:not_before_date)
  end

  def needed_by_date
    as_date(:needed_by_date)
  end

  def not_before_date_cannot_be_in_the_past
    if is_a_valid_date?(:not_before_date) and self.not_before_date < Date.today
      errors.add(:not_before_date, "can't be in the past")
    end
  end

  def needed_by_date_cannot_be_in_the_past
    if is_a_valid_date?(:needed_by_date) and self.needed_by_date < Date.today
      errors.add(:needed_by_date, "can't be in the past")
    end
  end

  def not_before_date_is_a_date
    if not is_a_valid_date?(:not_before_date)
      errors.add(:not_before_date, "is not a valid date (must be in the format yyyy-mm-dd)")
    end
  end

  def needed_by_date_is_a_date
    if not is_a_valid_date?(:needed_by_date)
      errors.add(:needed_by_date, "is not a valid date (must be in the format yyyy-mm-dd)")
    end
  end

  def not_before_date_cannot_come_after_the_needed_by_date
    if is_a_valid_date?(:needed_by_date) and is_a_valid_date?(:not_before_date) and not_before_date > needed_by_date
      errors.add(:not_before_date, "this date must be earlier than the 'needed by' date")
    end
  end

  protected
  def is_a_valid_date?(field_name)
    not populated?(field_name) and not as_date(field_name).nil?
  end

  def populated?(field_name)
    value = instance_variable_get("@#{field_name}")
    value.nil? or value.empty?
  end

  def as_date(field_name)
    begin
      value = instance_variable_get("@#{field_name}")
      Date.strptime(value, '%Y-%m-%d')
    rescue Exception
      nil
    end
  end
end