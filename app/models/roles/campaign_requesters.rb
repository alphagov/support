class CampaignRequesters
  def self.role_applies_to_user?(user)
    user.has_permission?('campaign_requesters')
  end
end