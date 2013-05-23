require 'shared/request'
require 'shared/with_tool_role_choice'
require 'support/requests/requested_user'

module Support
  module Requests
    class CreateNewUserRequest < Request
      include WithToolRoleChoice

      attr_accessor :requested_user, :additional_comments
      validates_presence_of :requested_user
      def requested_user_attributes=(attr)
        self.requested_user = RequestedUser.new(attr)
      end

      def self.label
        "Create new user"
      end
    end
  end
end