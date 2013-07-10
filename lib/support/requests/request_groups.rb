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
          RequestGroup.new("ERTP", [ErtpProblemReport]),
        ]
      end

      def each(&block)
        @groups.each(&block)
      end

      def all_request_class_names
        @groups.collect(&:request_classes).flatten.map {|request_class| request_class.name.split("::").last }
      end
    end
  end
end
