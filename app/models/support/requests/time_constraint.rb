require "active_model/model"

module Support
  module Requests
    class TimeConstraint
      include ActiveModel::Model
      attr_accessor :not_before_date, :not_before_time, :needed_by_date, :needed_by_time, :time_constraint_reason

      validates_date :needed_by_date, allow_blank: true, on_or_after: :today
      validates_date :not_before_date, allow_blank: true, on_or_after: :today
      validates_date :not_before_date, on_or_before: :needed_by_date, unless: proc { |c| c.needed_by_date.blank? || c.not_before_date.blank? },
                                       message: "'Must not be published before' date cannot be after Deadline"

      validates_time :not_before_time, allow_blank: true
      validates_time :needed_by_time, allow_blank: true

      validates_time :not_before_time, on_or_after: :now, unless: proc { |c|
        c.not_before_time.blank? || c.not_before_date != Time.zone.today.strftime("%d-%m-%Y")
      }
      validates_time :needed_by_time, on_or_after: :now, unless: proc { |c|
        c.needed_by_time.blank? || c.needed_by_date != Time.zone.today.strftime("%d-%m-%Y")
      }

      validates_time :not_before_time, on_or_before: :needed_by_time, unless: proc { |c|
        [c.needed_by_date, c.needed_by_time, c.not_before_date, c.not_before_time].any?(&:blank?) || c.needed_by_date != c.not_before_date
      }
    end
  end
end
