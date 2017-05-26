require 'spec_helper'

module Support
  module Requests
    describe TimeConstraint do
      def as_str(date)
        date.strftime("%d-%m-%Y")
      end

      it { should_not allow_value("xxx").for(:needed_by_date) }

      it { should allow_value(as_str(Date.tomorrow)).for(:needed_by_date) }
      it { should allow_value(as_str(Date.today)).for(:needed_by_date) }
      it { should_not allow_value(as_str(Date.yesterday)).for(:needed_by_date) }

      it { should_not allow_value("xxx").for(:not_before_date) }

      it { should allow_value(as_str(Date.tomorrow)).for(:not_before_date) }
      it { should allow_value(as_str(Date.today)).for(:not_before_date) }
      it { should_not allow_value(as_str(Date.yesterday)).for(:not_before_date) }

      it "allows the 'not before' and 'needed by' dates to be blank" do
        expect(TimeConstraint.new(not_before_date: "", needed_by_date: "")).to be_valid
      end

      it "doesn't allow the 'not before' date to be set after the 'needed by' date" do
        constraint = TimeConstraint.new(not_before_date: as_str(Date.tomorrow + 1.day),
                                        needed_by_date: as_str(Date.tomorrow))
        expect(constraint).to_not be_valid
        expect(constraint).to have_at_least(1).error_on(:not_before_date)
      end

      it "allows a blank not_before_date if the needed_by_date is set" do
        expect(TimeConstraint.new(needed_by_date: as_str(Date.tomorrow))).to be_valid
      end

      it "allows launch dates (i.e. not_before_date = needed_by_date)" do
        constraint = TimeConstraint.new(not_before_date: as_str(Date.tomorrow),
                                        needed_by_date: as_str(Date.tomorrow))
        expect(constraint).to be_valid
      end
    end
  end
end
