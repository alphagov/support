module Support
  module Requests
    class ChangeExistingUserRequest < Request
      attr_accessor :action,
                    :requested_user,
                    :additional_comments

      validate do |request|
        if request.requested_user && !request.requested_user.valid?
          errors.add :base, message: "The details of the user in question are either incomplete or invalid."
        end
      end
      validates :action, :requested_user, presence: true
      validates :action, inclusion: { in: ->(request) { request.action_options.values } }

      def requested_user_attributes=(attr)
        self.requested_user = Support::GDS::RequestedUser.new(attr)
      end

      def initialize(attrs = {})
        self.requested_user = Support::GDS::RequestedUser.new

        super
      end

      def for_new_user?
        action == "create_new_user"
      end

      def formatted_action
        action_options.key(action)
      end

      def self.action_options
        @action_options ||= {
          "Create a new user account" => "create_new_user",
          "Change an existing user's account" => "change_user",
        }
      end

      def action_options
        self.class.action_options
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
