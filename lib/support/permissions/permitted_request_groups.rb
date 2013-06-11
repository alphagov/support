require 'support/permissions/permitted_request_group'
require 'support/requests/request_groups'

module Support
  module Permissions
    class PermittedRequestGroups
      include Enumerable

      def initialize(user, request_groups = Support::Requests::RequestGroups.new)
        @user = user
        @request_groups = request_groups
      end

      def each(&block)
        wrapped_request_groups = @request_groups.collect { |request_group| PermittedRequestGroup.new(@user, request_group) }
        wrapped_request_groups.select { |request_group| request_group.accessible? }.each(&block)
      end
    end
  end
end
