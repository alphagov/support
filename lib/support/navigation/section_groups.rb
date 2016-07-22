require 'support/requests'
require 'support/navigation/request_section'
require 'support/navigation/section_group'

module Support
  module Navigation
    class SectionGroups
      include Enumerable
      include Support::Requests

      def initialize(current_user = nil)
        @current_user = current_user
        @groups = [
          SectionGroup.new("Content request",sections_for(ContentAdviceRequest, ContentChangeRequest, NewFeatureRequest, UnpublishContentRequest)),
          SectionGroup.new("User access", sections_for(AccountsPermissionsAndTrainingRequest, RemoveUserRequest)),
          SectionGroup.new("Campaigns", sections_for(CampaignRequest)),
          SectionGroup.new("Other requests", sections_for(AnalyticsRequest, GeneralRequest, TechnicalFaultReport)),
        ]
      end

      def each(&block)
        @groups.each(&block)
      end

      def all_sections
        @groups.flat_map(&:sections)
      end

      def all_request_class_names
        all_sections.map(&:request_class).map {|request_class| request_class.name.split("::").last }
      end

      private
      def sections_for(*request_classes)
        request_classes.map { |request_class| RequestSection.new(request_class, @current_user) }
      end
    end
  end
end
