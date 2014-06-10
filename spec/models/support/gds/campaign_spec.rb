require 'spec_helper'
require 'support/gds/campaign'

module Support
  module GDS
    describe Campaign do
      def as_str(date)
        date.strftime("%d-%m-%Y")
      end

      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:description) }

      it { should allow_value("some group or company").for(:affiliated_group_or_company) }
      it { should allow_value("http://www.google.com").for(:info_url) }

      it { should_not allow_value("xxx").for(:start_date) }

      it { should allow_value(as_str(Date.tomorrow)).for(:start_date) }
      it { should allow_value(as_str(Date.today)).for(:start_date) }
    end
  end
end
