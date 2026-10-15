module Support
  module Navigation
    class Sections
      include Enumerable

      ORDERED_INDEX_ITEMS = [
        Support::Requests::CreateNewUserOrTrainingRequest,
        Support::Requests::ChangeExistingUserRequest,
        Support::Requests::RemoveUserRequest,
        Support::Navigation::ContentAdviceRequestSection,
        Support::Requests::ContentChangeRequest,
        Support::Requests::UnpublishContentRequest,
        Support::Requests::ChangesToPublishingAppsRequest,
        Support::Requests::TechnicalFaultReport,
        Support::Requests::CampaignRequest,
        Support::Requests::LiveCampaignRequest,
        Support::Requests::ReportAnIssueWithGovukSearchResultsRequest,
        Support::Requests::ContentDataFeedback,
        Support::Requests::TaxonomyNewTopicRequest,
        Support::Requests::TaxonomyChangeTopicRequest,
        Support::Requests::AnalyticsRequest,
        Support::Requests::GeneralRequest,
      ].freeze

      def initialize(current_user)
        @sections = request_sections(current_user) + [
          Support::Navigation::FeedexSection.new(current_user),
          Support::Navigation::EmergencyContactDetailsSection.new(current_user),
        ]
      end

      def each(&block)
        @sections.each(&block)
      end

    private

      def request_sections(current_user)
        self.class::ORDERED_INDEX_ITEMS.map do |item_class|
          if item_class.module_parents.include? Support::Requests
            Support::Navigation::RequestSection.new(item_class, current_user)
          elsif item_class.module_parents.include? Support::Navigation
            item_class.new(current_user)
          end
        end
      end
    end
  end
end
