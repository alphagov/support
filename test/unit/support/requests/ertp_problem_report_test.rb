require 'test_helper'
require 'support/requests/ertp_problem_report'

module Support
  module Requests
    class ErtpProblemReportTest < Test::Unit::TestCase
      should validate_presence_of(:requester)
      should validate_presence_of(:control_center_ticket_number)
      should validate_presence_of(:local_authority_impacted)
      should validate_presence_of(:description)
      should validate_presence_of(:issue_category)

      should allow_value("1").for(:are_multiple_local_authorities_impacted)
      should allow_value("0").for(:are_multiple_local_authorities_impacted)
      should_not allow_value("xxx").for(:are_multiple_local_authorities_impacted)

      should allow_value("anything").for(:investigation)
      should allow_value("anything").for(:additional)

      should "provide a formatted value for 'are_multiple_local_authority_impacted'" do
        assert_equal "yes", ErtpProblemReport.new(are_multiple_local_authorities_impacted: "1").formatted_are_multiple_local_authorities_impacted
        assert_equal "no", ErtpProblemReport.new(are_multiple_local_authorities_impacted: "0").formatted_are_multiple_local_authorities_impacted
      end
    end
  end
end
