require 'cancan/ability'
require 'support/requests'
require 'support/requests/anonymous/explore'
require 'support/navigation/emergency_contact_details_section'

module Support
  module Permissions
    class Ability
      include CanCan::Ability
      include Support::Requests

      def initialize(user)
        can :read, :anonymous_feedback
        can :read, Support::Navigation::EmergencyContactDetailsSection

        can :create, AnalyticsRequest
        can :create, [GeneralRequest, TechnicalFaultReport, Support::Requests::Anonymous::Explore]
        can :create, [TaxonomyNewTopicRequest, TaxonomyChangeTopicRequest]

        can :create, :all if user.has_permission?('single_points_of_contact')

        can :create, CampaignRequest if user.has_permission?('campaign_requesters')

        if user.has_permission?('content_requesters')
          can :create, [
            ChangesToPublishingAppsRequest,
            ContentChangeRequest,
            ContentAdviceRequest,
            UnpublishContentRequest
          ]
        end

        can :create, [AccountsPermissionsAndTrainingRequest, RemoveUserRequest] if user.has_permission?('user_managers')

        can :create, [FoiRequest, NamedContact] if user.has_permission?('api_users')

        can :request, :global_export_request if user.has_permission?('feedex_exporters')
        can :request, :review_feedback if user.has_permission?('feedex_reviewers')
      end
    end
  end
end
