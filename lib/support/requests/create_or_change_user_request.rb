require 'support/requests/request'
require 'support/gds/with_tool_role_choice'
require 'support/gds/requested_user'

module Support
  module Requests
    class CreateOrChangeUserRequest < Request
      include Support::GDS::WithToolRoleChoice

      attr_accessor :requested_user, :additional_comments
      validates_presence_of :requested_user
      def requested_user_attributes=(attr)
        self.requested_user = Support::GDS::RequestedUser.new(attr)
      end

      def initialize(attrs = {})
        self.requested_user = Support::GDS::RequestedUser.new

        super
      end

      def self.label
        "Create or change user"
      end
    end
  end
end
