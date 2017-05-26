module Support
  module Requests
    class AccountsPermissionsAndTrainingRequest < Request
      include Support::GDS::WithUserNeeds

      attr_accessor :action, :requested_user, :additional_comments

      validate do |request|
        if request.requested_user && !request.requested_user.valid?
          errors[:base] << "The details of the user in question are either incomplete or invalid."
        end
      end
      validates_presence_of :action, :requested_user
      validates :action, inclusion: { in: %w(create_new_user change_user unsuspend_user) }

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
        Hash[action_options].key(action)
      end

      def action_options
        [
          ["Create a new user account", "create_new_user"],
          ["Change an existing user's account", "change_user"],
          ["Unsuspend an existing user's account", "unsuspend_user"],
        ]
      end

      def self.label
        "Accounts, permissions and training"
      end

      def self.description
        "Request a new account, change an account or unlock an account"
      end
    end
  end
end
