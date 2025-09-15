require "support/requests/with_time_constraint"

module Support
  module Requests
    class RemoveUserRequest < Request
      include WithTimeConstraint

      attr_accessor :user_name, :user_email, :reason_for_removal

      validates :user_name, :user_email, presence: true
      validates :user_email, format: { with: /@/ }

      def initialize(attributes = {})
        self.time_constraint = TimeConstraint.new

        super
      end

      def self.label
        "Remove user"
      end

      def self.description
        "Request to remove user access."
      end
    end
  end
end
