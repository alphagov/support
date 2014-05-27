require 'support/requests'
require 'support/requests/request_group'

module Support
  module Requests
    class RequestGroups
      include Enumerable
      include Support::Requests

      def initialize
        @groups = [
          RequestGroup.new("Content request", [ContentChangeRequest, NewFeatureRequest, UnpublishContentRequest]),
          RequestGroup.new("User Access", [CreateOrChangeUserRequest, RemoveUserRequest]),
          RequestGroup.new("Campaigns", [CampaignRequest]),
          RequestGroup.new("Other Issues", [AnalyticsRequest, GeneralRequest, TechnicalFaultReport]),
        ]
      end

      def each(&block)
        @groups.each(&block)
      end

      def all_request_class_names
        all_request_classes.collect {|request_class| request_class.name.split("::").last }
      end

      def all_request_classes
        @groups.flat_map(&:request_classes)
      end
    end
  end
end
