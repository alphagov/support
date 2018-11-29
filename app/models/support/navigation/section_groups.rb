module Support
  module Navigation
    class SectionGroups
      include Enumerable

      def initialize(current_user = nil)
        @current_user = current_user
        @groups = [
          Support::Navigation::SectionGroup.new("Content request", sections_for(Support::Requests::ContentAdviceRequest, Support::Requests::ContentChangeRequest, Support::Requests::UnpublishContentRequest)),
          Support::Navigation::SectionGroup.new("Technical support", sections_for(Support::Requests::ChangesToPublishingAppsRequest, Support::Requests::TechnicalFaultReport)),
          Support::Navigation::SectionGroup.new("User access", sections_for(Support::Requests::AccountsPermissionsAndTrainingRequest, Support::Requests::RemoveUserRequest)),
          Support::Navigation::SectionGroup.new("Campaigns", sections_for(Support::Requests::CampaignRequest, Support::Requests::LiveCampaignRequest)),
          Support::Navigation::SectionGroup.new("Feedback for tools in Beta", sections_for(Support::Requests::ContentPublisherFeedbackRequest, Support::Requests::ContentDataFeedback)),
          Support::Navigation::SectionGroup.new("Taxonomy requests", sections_for(Support::Requests::TaxonomyNewTopicRequest, Support::Requests::TaxonomyChangeTopicRequest)),
          Support::Navigation::SectionGroup.new("Other requests", sections_for(Support::Requests::AnalyticsRequest, Support::Requests::GeneralRequest)),
        ]
      end

      def each(&block)
        @groups.each(&block)
      end

      def all_sections
        @groups.flat_map(&:sections)
      end

      def all_request_class_names
        all_sections.map(&:request_class).map { |request_class| request_class.name.split("::").last }
      end

    private

      def sections_for(*request_classes)
        request_classes.map { |request_class| Support::Navigation::RequestSection.new(request_class, @current_user) }
      end
    end
  end
end
