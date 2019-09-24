require "active_support/core_ext"

module Support
  module Requests
    class BrexitCheckerRequest < Request
      attr_accessor :action_to_change, :description_of_change, :new_action_users,
                    :new_action_title, :new_action_consequence, :new_action_service_link,
                    :new_action_guidance_link, :new_action_lead_time,
                    :new_action_deadline, :new_action_comments, :new_action_priority

      def self.label
        "Get ready for Brexit checker: change request"
      end

      def self.description
        "Request a change to the Brexit checker"
      end
    end
  end
end
