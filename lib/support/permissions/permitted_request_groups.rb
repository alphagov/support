require 'support/permissions/permitted_request_group'

module Support
  module Permissions
    class PermittedRequestGroups
      include Enumerable

      def initialize(user, request_groups = RequestGroups.new)
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