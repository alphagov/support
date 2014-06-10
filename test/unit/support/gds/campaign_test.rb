require 'test_helper'
require 'support/gds/campaign'

module Support
  module GDS
    class CampaignTest < Test::Unit::TestCase
      def self.as_str(date)
        date.strftime("%d-%m-%Y")
      end

      def as_str(date)
        CampaignTest.as_str(date)
      end

      should validate_presence_of(:title)
      should validate_presence_of(:description)

      should allow_value("some group or company").for(:affiliated_group_or_company)
      should allow_value("http://www.google.com").for(:info_url)

      should_not allow_value("xxx").for(:start_date)

      should allow_value(as_str(Date.tomorrow)).for(:start_date)
      should allow_value(as_str(Date.today)).for(:start_date)
    end
  end
end
