module Support
  module GDS
    module WithRequestContext
      attr_accessor :request_context

      def self.included(base)
        base.validates_presence_of :request_context
        base.validates :request_context,
                       inclusion: {
                         in: %w[mainstream detailed_guidance],
                         message: "%{value} is not a valid option",
                       }
      end
    end
  end
end
