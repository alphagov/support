require "cancan/ability"

module Support
  module Permissions
    class Ability
      include CanCan::Ability

      def initialize(user)
        can :read, :anonymous_feedback
        can :read, Support::Navigation::EmergencyContactDetailsSection
        can :create, Support::Requests::AnalyticsRequest
        can :create, [Support::Requests::GeneralRequest, Support::Requests::TechnicalFaultReport, Support::Requests::Anonymous::Explore]
        can :create, [Support::Requests::TaxonomyNewTopicRequest, Support::Requests::TaxonomyChangeTopicRequest]
        can :create, Support::Requests::ReportAnIssueWithGovukSearchResultsRequest
        can :create, Support::Requests::ContentDataFeedback
        can :create, :all if user.has_permission?("single_points_of_contact")
        can :create, [Support::Requests::CampaignRequest, Support::Requests::LiveCampaignRequest] if user.has_permission?("campaign_requesters")
        if user.has_permission?("content_requesters")
          can :create,
              [
                Support::Requests::ChangesToPublishingAppsRequest,
                Support::Requests::ContentChangeRequest,
                Support::Requests::ContentAdviceRequest,
                Support::Requests::UnpublishContentRequest,
              ]
        end
        can :create, [Support::Requests::CreateNewUserRequest, Requests::ChangeExistingUserRequest, Support::Requests::RemoveUserRequest] if user.has_permission?("user_managers")
        can :request, :global_export_request if user.has_permission?("feedex_exporters")
        can :request, :review_feedback if user.has_permission?("feedex_reviewers")
      end
    end
  end
end
