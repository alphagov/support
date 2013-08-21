require 'cancan/ability'
require 'support/requests'

module Support
  module Permissions
    class Ability
      include CanCan::Ability
      include Support::Requests

      def initialize(user)
        can :manage, :all if user.has_permission?('single_points_of_contact')
        can :manage, CampaignRequest if user.has_permission?('campaign_requesters')    
        can :manage, [ NewFeatureRequest, ContentChangeRequest ] if user.has_permission?('content_requesters')
        can :manage, [ CreateOrChangeUserRequest, RemoveUserRequest ] if user.has_permission?('user_managers')
        can :manage, [ ErtpProblemReport ] if user.has_permission?('ertp')
        can :manage, [ FoiRequest, ProblemReport ] if user.has_permission?('api_users')

        can :manage, [GeneralRequest, AnalyticsRequest, TechnicalFaultReport, UnpublishContentRequest]
      end
    end
  end
end
