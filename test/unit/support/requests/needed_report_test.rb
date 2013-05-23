require 'test_helper'
require 'support/requests/needed_report'

module Support
  module Requests
    class NeededReportTest < Test::Unit::TestCase
      should validate_presence_of(:reporting_period_start)
      should validate_presence_of(:reporting_period_end)
      should validate_presence_of(:pages_or_sections)
      should validate_presence_of(:frequency)

      should allow_value("one-off").for(:frequency)
      should allow_value("weekly").for(:frequency)
      should allow_value("monthly").for(:frequency)
      should_not allow_value("xxx").for(:frequency)

      should allow_value(nil).for(:format)
      should allow_value("pdf").for(:format)
      should allow_value("csv").for(:format)
      should_not allow_value("xxx").for(:format)

      should allow_value("KPI abc").for(:non_standard_requirements)

      should "provide a text representation of the reporting period" do
        report = NeededReport.new(reporting_period_start: "Jan 2012", reporting_period_end: "Dec 2012")
        assert_equal "From Jan 2012 to Dec 2012", report.reporting_period
      end
    end
  end
end