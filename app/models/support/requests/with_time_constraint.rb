module Support
  module Requests
    module WithTimeConstraint
      def self.included(base)
        base.validate do |request|
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
    end
  end
end
