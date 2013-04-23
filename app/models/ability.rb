class Ability

  include CanCan::Ability

  def initialize(user)
    case
    when user.has_permission?('single_points_of_contact')
      can :manage, :all
    when user.has_permission?('campaign_requesters')
      can :manage, CampaignRequest
    when user.has_permission?('content_requesters')
      can :manage, [ NewFeatureRequest, ContentChangeRequest ]
    end

    can :manage, [GeneralRequest, AnalyticsRequest]
  end
end