module Support
  module Requests
    class TechnicalFaultReport < Request
      attr_accessor :fault_context, :fault_specifics, :actions_leading_to_problem, :what_happened, :what_should_have_happened

      validates_presence_of :fault_context, :fault_specifics, :actions_leading_to_problem, :what_happened, :what_should_have_happened
      validate do |report|
        if report.fault_context && !report.fault_context.valid?
          errors[:base] << "The source of the fault is not set."
        end
      end

      # This is temporary while Content Publisher is in private beta.
      # Content Publisher tickets will be assigned to Humin Miah.
      CONTENT_PUBLISHER_ASSIGNEE = 3512638809

      def initialize(opts = {})
        super
        self.fault_context ||= Support::GDS::UserFacingComponent.new
      end

      def fault_context_attributes=(attr)
        self.fault_context = Support::GDS::UserFacingComponents.find(attr)
      end

      def fault_context_options
        Support::GDS::UserFacingComponents.all
      end

      def inside_government_related?
        fault_context && fault_context.inside_government_related?
      end

      def self.label
        "Report a technical fault to GDS"
      end

      def self.description
        "Report something that is not working with any publishing application, eg Whitehall, finders or specialist publisher. Also use for any urgent technical changes"
      end

      def assignee_id
        # temporary while Content Publisher is in private beta
        return unless fault_context.id == "content_publisher"
        CONTENT_PUBLISHER_ASSIGNEE
      end
    end
  end
end
