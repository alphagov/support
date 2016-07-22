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
        can :create, :all if user.has_permission?('single_points_of_contact')
        can :create, CampaignRequest if user.has_permission?('campaign_requesters')
        can :create, [ NewFeatureRequest, ContentChangeRequest ] if user.has_permission?('content_requesters')
        can :create, [ AccountsPermissionsAndTrainingRequest, RemoveUserRequest ] if user.has_permission?('user_managers')
        can :create, [ FoiRequest, NamedContact ] if user.has_permission?('api_users')

        can :read, :anonymous_feedback
        can :read, Support::Navigation::EmergencyContactDetailsSection
        can :create, Support::Requests::Anonymous::Explore
        can :create, [GeneralRequest, AnalyticsRequest, ContentAdviceRequest, TechnicalFaultReport, UnpublishContentRequest]
      end
    end
  end
end
