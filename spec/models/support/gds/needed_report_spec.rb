require 'spec_helper'
require 'support/gds/needed_report'

module Support
  module GDS
    describe NeededReport do
      it { should validate_presence_of(:reporting_period_start) }
      it { should validate_presence_of(:reporting_period_end) }
      it { should validate_presence_of(:pages_or_sections) }
      it { should validate_presence_of(:frequency) }

      it { should allow_value("one-off").for(:frequency) }
      it { should allow_value("weekly").for(:frequency) }
      it { should allow_value("monthly").for(:frequency) }
      it { should_not allow_value("xxx").for(:frequency) }

      it { should allow_value(nil).for(:format) }
      it { should allow_value("pdf").for(:format) }
      it { should allow_value("csv").for(:format) }
      it { should_not allow_value("xxx").for(:format) }

      it { should allow_value("KPI abc").for(:non_standard_requirements) }

      it "provides a text representation of the reporting period" do
        report = NeededReport.new(reporting_period_start: "Jan 2012", reporting_period_end: "Dec 2012")
        expect(report.reporting_period).to eq("From Jan 2012 to Dec 2012")
      end
    end
  end
end
