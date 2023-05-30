require "rails_helper"

module Support
  module Requests
    describe TimeConstraint do
      def as_str(date)
        date.strftime("%d-%m-%Y")
      end

      def time_as_str(time)
        time.strftime("%H:%M")
      end

      it { should_not allow_value("xxx").for(:needed_by_date) }

      it { should allow_value(as_str(Date.tomorrow)).for(:needed_by_date) }
      it { should allow_value(as_str(Time.zone.today)).for(:needed_by_date) }
      it { should_not allow_value(as_str(Date.yesterday)).for(:needed_by_date) }

      it { should_not allow_value("xxx").for(:not_before_date) }

      it { should allow_value(as_str(Date.tomorrow)).for(:not_before_date) }
      it { should allow_value(as_str(Time.zone.today)).for(:not_before_date) }
      it { should_not allow_value(as_str(Date.yesterday)).for(:not_before_date) }

      it "allows the 'not before' and 'needed by' dates to be blank" do
        expect(TimeConstraint.new(not_before_date: "", needed_by_date: "")).to be_valid
      end

      it "doesn't allow the 'not before' date to be set after the 'needed by' date" do
        constraint = TimeConstraint.new(
          not_before_date: as_str(Date.tomorrow + 1.day),
          needed_by_date: as_str(Date.tomorrow),
        )
        expect(constraint).to_not be_valid
        expect(constraint).to have_at_least(1).error_on(:not_before_date)
      end

      it "doesn't allow the 'not before' time to be set after the 'needed by' time, if the 'not before' date and 'not before' time are the same" do
        constraint = TimeConstraint.new(
          not_before_date: as_str(Date.tomorrow),
          needed_by_date: as_str(Date.tomorrow),
          not_before_time: "12:00",
          needed_by_time: "11:00",
        )
        expect(constraint).to_not be_valid
        expect(constraint).to have_at_least(1).error_on(:not_before_time)
      end

      it "allows the 'not before' time to be set after the 'needed by' time, if the 'not before' date and 'not before' time are different" do
        constraint = TimeConstraint.new(
          not_before_date: as_str(Date.tomorrow),
          needed_by_date: as_str(Date.tomorrow + 1.day),
          not_before_time: "12:00",
          needed_by_time: "11:00",
        )
        expect(constraint).to be_valid
      end

      it "validates that the 'not before' time is after now" do
        constraint = TimeConstraint.new(
          not_before_date: as_str(Time.zone.today),
          not_before_time: time_as_str(Time.zone.now - 1.minute),
        )
        expect(constraint).to_not be_valid
        expect(constraint).to have_at_least(1).error_on(:not_before_time)

        constraint = TimeConstraint.new(
          not_before_date: as_str(Date.tomorrow),
          not_before_time: time_as_str(Time.zone.now - 1.minute),
        )
        expect(constraint).to be_valid
      end

      it "validates that the 'needed by' time is after now" do
        constraint = TimeConstraint.new(
          needed_by_date: as_str(Time.zone.today),
          needed_by_time: time_as_str(Time.zone.now - 1.minute),
        )
        expect(constraint).to_not be_valid
        expect(constraint).to have_at_least(1).error_on(:needed_by_time)

        constraint = TimeConstraint.new(
          needed_by_date: as_str(Time.zone.tomorrow),
          needed_by_time: time_as_str(Time.zone.now - 1.minute),
        )
        expect(constraint).to be_valid
      end

      it "allows a blank not_before_date if the needed_by_date is set" do
        expect(TimeConstraint.new(needed_by_date: as_str(Date.tomorrow))).to be_valid
      end

      it "allows launch dates (i.e. not_before_date = needed_by_date)" do
        constraint = TimeConstraint.new(
          not_before_date: as_str(Date.tomorrow),
          needed_by_date: as_str(Date.tomorrow),
        )
        expect(constraint).to be_valid
      end

      it "validates time formats" do
        %i[needed_by_time not_before_time].each do |attribute|
          should allow_value("14:00").for(attribute)
          should_not allow_value("25:00").for(attribute)
          should_not allow_value("14:60").for(attribute)
          should_not allow_value("14").for(attribute)
          should_not allow_value("1400").for(attribute)
          should_not allow_value("14:00 PM").for(attribute)
          should_not allow_value("2 : 00").for(attribute)
          # These values should never happen in practice because the dropdown menu uses 24 hour time,
          # but they're still valid
          should allow_value("2:00PM").for(attribute)
          should allow_value("2:00pm").for(attribute)
        end
      end
    end
  end
end
