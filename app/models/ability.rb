class Ability

  include CanCan::Ability

  def initialize(user)
    can :manage, :all if user.has_permission?('single_points_of_contact')
    can :manage, CampaignRequest if user.has_permission?('campaign_requesters')    
    can :manage, [ NewFeatureRequest, ContentChangeRequest ] if user.has_permission?('content_requesters')

    can :manage, [GeneralRequest, AnalyticsRequest]
  end
end