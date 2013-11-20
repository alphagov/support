require 'cancan/ability'
require 'support/requests'

module Support
  module Permissions
    class Ability
      include CanCan::Ability
      include Support::Requests

      def initialize(user)
        can :create, :all if user.has_permission?('single_points_of_contact')
        can :create, CampaignRequest if user.has_permission?('campaign_requesters')    
        can :create, [ NewFeatureRequest, ContentChangeRequest ] if user.has_permission?('content_requesters')
        can :create, [ CreateOrChangeUserRequest, RemoveUserRequest ] if user.has_permission?('user_managers')
        can :create, [ FoiRequest, Anonymous::ProblemReport, Anonymous::LongFormContact, Anonymous::ServiceFeedback, NamedContact ] if user.has_permission?('api_users')

        can :read, Anonymous::ProblemReport if user.has_permission?('feedex')
        can :create, Support::Requests::Anonymous::Explore if user.has_permission?('feedex')
        can :create, [GeneralRequest, AnalyticsRequest, TechnicalFaultReport, UnpublishContentRequest]
      end
    end
  end
end
