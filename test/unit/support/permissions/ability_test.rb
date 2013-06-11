require 'test_helper'
require 'support/permissions/ability'

module Support
  module Permissions
    class AbilityTest < Test::Unit::TestCase
      def test_user_can_have_multiple_permissions
        user = User.new(permissions: ["content_requesters", "campaign_requesters"])
        ability = Ability.new(user)
        assert ability.can?(:manage, Support::Requests::CampaignRequest)
        assert ability.can?(:manage, Support::Requests::ContentChangeRequest)
      end
    end
  end
end