require "support/requests/with_time_constraint"

module Support
  module Requests
    class ChangesToPublishingAppsRequest < Request
      attr_accessor :title, :user_need, :feature_evidence

      validates :user_need, presence: true

      def self.label
        "Changes to publishing applications or technical advice"
      end

      def self.description
        "Request for changes or new features for any publishing applications or ask for technical advice. Also used for transitioning new sites to GOV.UK"
      end
    end
  end
end
