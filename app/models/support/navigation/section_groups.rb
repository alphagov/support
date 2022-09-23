module Support
  module Navigation
    class SectionGroups
      include Enumerable

      def initialize(current_user = nil)
        @current_user = current_user
        @groups = [
          Support::Navigation::SectionGroup.new("Content request", content_requests),
          Support::Navigation::SectionGroup.new("Technical support", technical_support_requests),
          Support::Navigation::SectionGroup.new("User access", user_access_requests),
          Support::Navigation::SectionGroup.new("Campaigns", campaign_requests),
          Support::Navigation::SectionGroup.new("Feedback for tools in Beta", feedback_requests),
          Support::Navigation::SectionGroup.new("Topic taxonomy requests", taxonomy_requests),
          Support::Navigation::SectionGroup.new("Other requests", other_requests),
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

      def content_requests
        sections_for(
          Support::Requests::ContentAdviceRequest,
          Support::Requests::ContentChangeRequest,
          Support::Requests::UnpublishContentRequest,
        )
      end

      def technical_support_requests
        sections_for(
          Support::Requests::ChangesToPublishingAppsRequest,
          Support::Requests::TechnicalFaultReport,
        )
      end

      def user_access_requests
        sections_for(
          Support::Requests::AccountsPermissionsAndTrainingRequest,
          Support::Requests::RemoveUserRequest,
        )
      end

      def campaign_requests
        sections_for(
          Support::Requests::CampaignRequest,
          Support::Requests::LiveCampaignRequest,
        )
      end

      def feedback_requests
        sections_for(
          Support::Requests::ContentPublisherFeedbackRequest,
          Support::Requests::ContentDataFeedback,
        )
      end

      def taxonomy_requests
        sections_for(
          Support::Requests::TaxonomyNewTopicRequest,
          Support::Requests::TaxonomyChangeTopicRequest,
        )
      end

      def other_requests
        sections_for(
          Support::Requests::AnalyticsRequest,
          Support::Requests::GeneralRequest,
        )
      end
    end
  end
end
