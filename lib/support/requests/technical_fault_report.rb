require 'support/requests/request'

require 'support/gds/user_facing_components'
require 'support/gds/user_facing_component'

module Support
  module Requests
    class TechnicalFaultReport < Request
      include Support::GDS

      attr_accessor :fault_context, :fault_specifics, :actions_leading_to_problem, :what_happened, :what_should_have_happened

      validates_presence_of :fault_context, :fault_specifics, :actions_leading_to_problem, :what_happened, :what_should_have_happened
      validate do |report|
        if report.fault_context and not report.fault_context.valid?
          errors[:base] << "The source of the fault is not set."
        end
      end

      def initialize(opts = {})
        super
        self.fault_context ||= UserFacingComponent.new
      end

      def fault_context_attributes=(attr)
        self.fault_context = UserFacingComponents.find(attr)
      end

      def fault_context_options
        UserFacingComponents.all
      end

      def inside_government_related?
        fault_context and fault_context.inside_government_related?
      end

      def self.label
        "Report a technical fault"
      end

      def self.description
        "Report a technical fault to GDS"
      end
    end
  end
end
