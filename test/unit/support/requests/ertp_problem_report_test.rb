require 'test_helper'
require 'support/requests/ertp_problem_report'

module Support
  module Requests
    class ErtpProblemReportTest < Test::Unit::TestCase
      should validate_presence_of(:requester)
      should validate_presence_of(:control_center_ticket_number)
      should validate_presence_of(:local_authority_impacted)
      should validate_presence_of(:description)
      should validate_presence_of(:ems_supplier)
      should validate_presence_of(:incident_stage)
      should validate_presence_of(:priority)

      should allow_value("1").for(:are_multiple_local_authorities_impacted)
      should allow_value("0").for(:are_multiple_local_authorities_impacted)
      should_not allow_value("xxx").for(:are_multiple_local_authorities_impacted)

      ["low", "normal", "high", "urgent"].each { |prio| should allow_value(prio).for(:priority) }
      should_not allow_value("xxx").for(:priority)

      should allow_value("anything").for(:investigation)
      should allow_value("anything").for(:additional)

      should "provide a formatted value for 'are_multiple_local_authority_impacted'" do
        assert_equal "yes", ErtpProblemReport.new(are_multiple_local_authorities_impacted: "1").formatted_are_multiple_local_authorities_impacted
        assert_equal "no", ErtpProblemReport.new(are_multiple_local_authorities_impacted: "0").formatted_are_multiple_local_authorities_impacted
      end

      should "provide a formatted priority" do
        assert_equal "1 - urgent", ErtpProblemReport.new(priority: "urgent").formatted_priority
        assert_equal "4 - low", ErtpProblemReport.new(priority: "low").formatted_priority
      end
    end
  end
end
