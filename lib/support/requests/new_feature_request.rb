require 'support/requests/request'
require 'support/requests/with_time_constraint'
require 'support/gds/with_request_context'

module Support
  module Requests
    class NewFeatureRequest < Request
      include WithTimeConstraint
      include Support::GDS::WithRequestContext

      attr_accessor :title, :user_need, :url_of_example
      validates_presence_of :user_need

      def initialize(attributes = {})
        self.time_constraint = TimeConstraint.new
        
        super
      end

      def self.label
        "New feature/need"
      end
    end
  end
end
