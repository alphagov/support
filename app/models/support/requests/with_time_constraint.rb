module Support
  module Requests
    module WithTimeConstraint
      def self.included(base)
        base.validate do |request|
          set_time_constraint_requirement

          if request.time_constraint && !request.time_constraint.valid?
            request.time_constraint.errors.each do |error|
              errors.add(error.attribute, error.message)
            end
          end
        end
      end
      attr_accessor :time_constraint

      def time_constraint_attributes=(attr)
        self.time_constraint = TimeConstraint.new(attr)
      end

      def set_time_constraint_requirement
        return unless respond_to? :deadline
        return if time_constraint.blank?

        time_constraint.is_required = (deadline == "Yes")
      end
    end
  end
end
