require 'support/requests/request'
require 'support/requests/with_time_constraint'
require 'support/gds/with_request_context'

module Support
  module Requests
    class NewFeatureRequest < Request
      include WithTimeConstraint
      include Support::GDS::WithRequestContext

      attr_accessor :user_need, :url_of_example
      validates_presence_of :user_need

      def self.label
        "New feature/need"
      end
    end
  end
end