require 'test_helper'
require 'support/permissions/ability'
require 'support/requests/anonymous/problem_report'
require 'support/requests/anonymous/explore'

module Support
  module Permissions
    class AbilityTest < Test::Unit::TestCase
      def test_user_can_have_multiple_permissions
        user = User.new(permissions: ["content_requesters", "campaign_requesters"])
        ability = Ability.new(user)
        assert ability.can?(:create, Support::Requests::CampaignRequest)
        assert ability.can?(:create, Support::Requests::ContentChangeRequest)
      end

      def test_feedex_users_can_read_problem_reports
        ability = Ability.new(User.new(permissions: ["feedex"]))
        assert ability.can?(:read, Support::Requests::Anonymous::ProblemReport)
      end

      def test_feedex_users_can_explore_anonymous_feedback
        ability = Ability.new(User.new(permissions: ["feedex"]))
        assert ability.can?(:create, Support::Requests::Anonymous::Explore)
      end
    end
  end
end
