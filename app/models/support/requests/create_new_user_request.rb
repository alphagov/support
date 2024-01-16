module Support
  module Requests
    class CreateNewUserRequest < Request
      attr_accessor :requested_user,
                    :additional_comments

      validate do |request|
        if request.requested_user && !request.requested_user.valid?
          errors.add :base, message: "The details of the user in question are either incomplete or invalid."
        end
      end
      validates :requested_user, presence: true
      validates :additional_comments, presence: true

      def requested_user_attributes=(attr)
        self.requested_user = Support::GDS::RequestedUser.new(attr)
      end

      def initialize(attrs = {})
        self.requested_user = Support::GDS::RequestedUser.new

        super
      end

      def action
        "create_new_user"
      end

      def for_new_user?
        true
      end

      def formatted_action
        "Create a new user account"
      end

      def inside_government_related?
        false
      end

      def self.label
        "Create a new user"
      end

      def self.description
        "Request a new user account."
      end
    end
  end
end
