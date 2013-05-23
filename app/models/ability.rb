require 'support/requests'

class Ability
  include CanCan::Ability
  include Support::Requests

  def initialize(user)
    can :manage, :all if user.has_permission?('single_points_of_contact')
    can :manage, CampaignRequest if user.has_permission?('campaign_requesters')    
    can :manage, [ NewFeatureRequest, ContentChangeRequest ] if user.has_permission?('content_requesters')
    can :manage, [ CreateNewUserRequest, RemoveUserRequest ] if user.has_permission?('user_managers')

    can :manage, [GeneralRequest, AnalyticsRequest, TechnicalFaultReport]
  end
end