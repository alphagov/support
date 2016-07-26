require 'support/requests/request'
require 'support/requests/with_time_constraint'

module Support
  module Requests
    class ChangesToPublishingAppsRequest < Request
      include WithTimeConstraint

      attr_accessor :title, :user_need, :url_of_example
      validates_presence_of :user_need

      def initialize(attributes = {})
        self.time_constraint = TimeConstraint.new

        super
      end

      def self.label
        "Changes to publishing applications or technical advice"
      end

      def self.description
        "Request for changes or new features for any publishing applications or ask for technical advice. Also used for transitioning new sites to GOV.UK"
      end
    end
  end
end
