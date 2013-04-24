require 'test_helper'

class AbilityTest < Test::Unit::TestCase
  def test_user_can_have_multiple_permissions
    user = User.new(permissions: ["content_requesters", "campaign_requesters"])
    ability = Ability.new(user)
    assert ability.can?(:manage, CampaignRequest)
    assert ability.can?(:manage, ContentChangeRequest)
  end
end