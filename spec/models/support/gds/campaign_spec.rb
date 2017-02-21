require 'spec_helper'
require 'support/gds/campaign'

module Support
  module GDS
    describe Campaign do
      def as_str(date)
        date.strftime("%d-%m-%Y")
      end

      subject { Campaign.new(title: 'Test Title', other_dept_or_agency: 'Test Department',
                             signed_campaign: 'Test Signer', start_date: as_str(Date.today),
                             end_date: as_str(Date.tomorrow), description: 'Test Description',
                             call_to_action: 'Test Call to Action', success_measure: 'Test Measure Success',
                             proposed_url: 'example.campaign.gov.uk', site_metadescription: 'tag1, tag2',
                             cost_of_campaign: 1200) }

      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:signed_campaign) }
      it { should validate_presence_of(:start_date) }
      it { should validate_presence_of(:end_date) }
      it { should validate_presence_of(:description) }
      it { should validate_presence_of(:call_to_action) }
      it { should validate_presence_of(:success_measure) }
      it { should validate_presence_of(:proposed_url) }
      it { should validate_presence_of(:site_metadescription) }
      it { should validate_presence_of(:cost_of_campaign) }

      it { should allow_value("example.campaign.gov.uk").for(:proposed_url) }
      it { should_not allow_value("mycampaign.gov.uk").for(:proposed_url) }

      it { should_not allow_value("xxx").for(:start_date) }
      it { should_not allow_value("xxx").for(:end_date) }

      it { should not(allow_value(as_str(Date.tomorrow)).for(:start_date)) }
      it { should allow_value(as_str(Date.today)).for(:start_date) }

      it { should allow_value(as_str(Date.tomorrow)).for(:end_date) }
      it { should not(allow_value(as_str(Date.today)).for(:end_date)) }

      it { should not(allow_value('1200').for(:campaign_cost)) }
    end
  end
end
