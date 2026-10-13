module Support
  module Navigation
    class Sections
      include Enumerable

      ORDERED_REQUEST_FORMS = [
        Support::Requests::CreateNewUserOrTrainingRequest,
        Support::Requests::ChangeExistingUserRequest,
        Support::Requests::RemoveUserRequest,
        Support::Requests::ContentAdviceRequest,
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
        ORDERED_REQUEST_FORMS.map do |request_class|
          Support::Navigation::RequestSection.new(request_class, current_user)
        end
      end
    end
  end
end
