module Support
  module GDS
    module WithRequestContext
      attr_accessor :request_context

      def self.included(base)
        base.validates_presence_of :request_context
        base.validates :request_context, inclusion: { 
          in: %w(mainstream inside_government detailed_guidance),
          message: "%{value} is not valid option"
        }
      end

      def formatted_request_context
        Hash[request_context_options].key(request_context)
      end

      def inside_government_related?
        %w{inside_government detailed_guidance}.include?(request_context)
      end

      def request_context_options
        [
          ["Detailed Guidance", "detailed_guidance"],
          ["Inside Government", "inside_government"],
          ["Mainstream (business/citizen)", "mainstream"],
        ]
      end
    end
  end
end