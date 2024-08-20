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

      it "should not allow needed by date values to be random characters " do
        constraint = TimeConstraint.new(
          needed_by_day: "xxx",
          needed_by_month: "xxx",
          needed_by_year: "xxx",
        )
        expect(constraint).to_not be_valid
      end

      it "allows the 'needed by' date to be in the future" do
        constraint = TimeConstraint.new(
          needed_by_day: Time.zone.tomorrow.strftime("%d"),
          needed_by_month: Time.zone.tomorrow.strftime("%m"),
          needed_by_year: Time.zone.tomorrow.strftime("%Y"),
        )
        expect(constraint).to be_valid
      end

      it "allows the 'needed by' date to be today" do
        constraint = TimeConstraint.new(
          needed_by_day: Time.zone.today.strftime("%d"),
          needed_by_month: Time.zone.today.strftime("%m"),
          needed_by_year: Time.zone.today.strftime("%Y"),
        )
        expect(constraint).to be_valid
      end

      it "should not allow the 'needed by' date to be in the past" do
        constraint = TimeConstraint.new(
          needed_by_day: Time.zone.yesterday.strftime("%d"),
          needed_by_month: Time.zone.yesterday.strftime("%m"),
          needed_by_year: Time.zone.yesterday.strftime("%Y"),
        )
        expect(constraint).to_not be_valid
      end

      it "allows the 'not before' date to be in the future" do
        constraint = TimeConstraint.new(
          not_before_day: Time.zone.tomorrow.strftime("%d"),
          not_before_month: Time.zone.tomorrow.strftime("%m"),
          not_before_year: Time.zone.tomorrow.strftime("%Y"),
        )
        expect(constraint).to be_valid
      end

      it "allows the 'not before' date to be today" do
        constraint = TimeConstraint.new(
          not_before_day: Time.zone.today.strftime("%d"),
          not_before_month: Time.zone.today.strftime("%m"),
          not_before_year: Time.zone.today.strftime("%Y"),
        )
        expect(constraint).to be_valid
      end

      it "doesn't allow the 'not before' date to be in the past" do
        constraint = TimeConstraint.new(
          not_before_day: Time.zone.yesterday.strftime("%d"),
          not_before_month: Time.zone.yesterday.strftime("%m"),
          not_before_year: Time.zone.yesterday.strftime("%Y"),
        )
        expect(constraint).to_not be_valid
      end

      it "allows the 'not before' and 'needed by' date fields to be blank" do
        expect(TimeConstraint.new(
                 not_before_day: "",
                 not_before_month: "",
                 not_before_year: "",
                 needed_by_day: "",
                 needed_by_month: "",
                 needed_by_year: "",
               )).to be_valid
      end

      it "doesn't allow the 'not before' date to be set after the 'needed by' date" do
        constraint = TimeConstraint.new(
          not_before_day: (Time.zone.tomorrow + 1.day).strftime("%d"),
          not_before_month: (Time.zone.tomorrow + 1.day).strftime("%m"),
          not_before_year: (Time.zone.tomorrow + 1.day).strftime("%Y"),
          needed_by_day: Time.zone.tomorrow.strftime("%d"),
          needed_by_month: Time.zone.tomorrow.strftime("%m"),
          needed_by_year: Time.zone.tomorrow.strftime("%Y"),
        )
        expect(constraint).to_not be_valid
        expect(constraint).to have_at_least(1).error_on(:not_before_date)
      end

      it "doesn't allow the 'not before' time to be set after the 'needed by' time, if the 'not before' date and 'not before' time are the same" do
        constraint = TimeConstraint.new(
          not_before_day: Time.zone.tomorrow.strftime("%d"),
          not_before_month: Time.zone.tomorrow.strftime("%m"),
          not_before_year: Time.zone.tomorrow.strftime("%Y"),
          needed_by_day: Time.zone.tomorrow.strftime("%d"),
          needed_by_month: Time.zone.tomorrow.strftime("%m"),
          needed_by_year: Time.zone.tomorrow.strftime("%Y"),
          not_before_time: "12:00",
          needed_by_time: "11:00",
        )
        expect(constraint).to_not be_valid
        expect(constraint).to have_at_least(1).error_on(:not_before_time)
      end

      it "allows the 'not before' time to be set after the 'needed by' time, if the 'not before' date and 'not before' time are different" do
        constraint = TimeConstraint.new(
          not_before_day: Time.zone.tomorrow.strftime("%d"),
          not_before_month: Time.zone.tomorrow.strftime("%m"),
          not_before_year: Time.zone.tomorrow.strftime("%Y"),
          needed_by_day: (Time.zone.tomorrow + 1.day).strftime("%d"),
          needed_by_month: (Time.zone.tomorrow + 1.day).strftime("%m"),
          needed_by_year: (Time.zone.tomorrow + 1.day).strftime("%Y"),
          not_before_time: "12:00",
          needed_by_time: "11:00",
        )
        expect(constraint).to be_valid
      end

      it "validates that the 'not before' time is after now" do
        constraint = TimeConstraint.new(
          not_before_day: Time.zone.today.strftime("%d"),
          not_before_month: Time.zone.today.strftime("%m"),
          not_before_year: Time.zone.today.strftime("%Y"),
          not_before_time: time_as_str(Time.zone.now - 1.minute),
        )
        expect(constraint).to_not be_valid
        expect(constraint).to have_at_least(1).error_on(:not_before_time)

        constraint = TimeConstraint.new(
          not_before_day: Time.zone.tomorrow.strftime("%d"),
          not_before_month: Time.zone.tomorrow.strftime("%m"),
          not_before_year: Time.zone.tomorrow.strftime("%Y"),
          not_before_time: time_as_str(Time.zone.now - 1.minute),
        )
        expect(constraint).to be_valid
      end

      it "validates that the 'needed by' time is after now" do
        constraint = TimeConstraint.new(
          needed_by_day: Time.zone.today.strftime("%d"),
          needed_by_month: Time.zone.today.strftime("%m"),
          needed_by_year: Time.zone.today.strftime("%Y"),
          needed_by_time: time_as_str(Time.zone.now - 1.minute),
        )
        expect(constraint).to_not be_valid
        expect(constraint).to have_at_least(1).error_on(:needed_by_time)

        constraint = TimeConstraint.new(
          needed_by_day: Time.zone.tomorrow.strftime("%d"),
          needed_by_month: Time.zone.tomorrow.strftime("%m"),
          needed_by_year: Time.zone.tomorrow.strftime("%Y"),
          needed_by_time: time_as_str(Time.zone.now - 1.minute),
        )
        expect(constraint).to be_valid
      end

      it "allows a blank not_before_date if the needed_by_date is set" do
        expect(TimeConstraint.new(
                 needed_by_day: Time.zone.tomorrow.strftime("%d"),
                 needed_by_month: Time.zone.tomorrow.strftime("%m"),
                 needed_by_year: Time.zone.tomorrow.strftime("%Y"),
               )).to be_valid
      end

      it "allows launch dates (i.e. not_before_date = needed_by_date)" do
        constraint = TimeConstraint.new(
          not_before_day: Time.zone.tomorrow.strftime("%d"),
          not_before_month: Time.zone.tomorrow.strftime("%m"),
          not_before_year: Time.zone.tomorrow.strftime("%Y"),
          needed_by_day: Time.zone.tomorrow.strftime("%d"),
          needed_by_month: Time.zone.tomorrow.strftime("%m"),
          needed_by_year: Time.zone.tomorrow.strftime("%Y"),
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

      it "returns the correct error message when 'not before' date is after 'needed by' date" do
        constraint = Support::Requests::TimeConstraint.new(
          not_before_day: (Time.zone.today + 2.days).strftime("%d"),
          not_before_month: (Time.zone.today + 2.days).strftime("%m"),
          not_before_year: (Time.zone.today + 2.days).strftime("%Y"),
          needed_by_day: (Time.zone.today + 1.day).strftime("%d"),
          needed_by_month: (Time.zone.today + 1.day).strftime("%m"),
          needed_by_year: (Time.zone.today + 1.day).strftime("%Y"),
        )

        constraint.valid?

        expect(constraint.errors[:not_before_date]).to include("'Must not be published before' date cannot be after Deadline")
      end
    end
  end
end
