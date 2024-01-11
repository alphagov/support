module Support
  module Requests
    class ChangeExistingUserRequest < Request
      attr_accessor :requested_user,
                    :additional_comments

      validate do |request|
        if request.requested_user && !request.requested_user.valid?
          errors.add :base, message: "The details of the user in question are either incomplete or invalid."
        end
      end
      validates :requested_user, presence: true

      def requested_user_attributes=(attr)
        self.requested_user = Support::GDS::RequestedUser.new(attr)
      end

      def initialize(attrs = {})
        self.requested_user = Support::GDS::RequestedUser.new

        super
      end

      def action
        "change_user"
      end

      def for_new_user?
        false
      end

      def formatted_action
        "Change an existing user's account"
      end

      def inside_government_related?
        false
      end

      def self.label
        "Change existing user"
      end

      def self.description
        "Request a change to an existing user."
      end
    end
  end
end
