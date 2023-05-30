require "active_model/model"

module Support
  module Requests
    class TimeConstraint
      include ActiveModel::Model
      attr_accessor :not_before_date, :not_before_time, :needed_by_date, :needed_by_time, :time_constraint_reason

      validates_date :needed_by_date, allow_nil: true, allow_blank: true, on_or_after: :today
      validates_date :not_before_date, allow_nil: true, allow_blank: true, on_or_after: :today
      validates_date :not_before_date, on_or_before: :needed_by_date, unless: proc { |c| c.needed_by_date.blank? || c.not_before_date.blank? }
    end
  end
end
