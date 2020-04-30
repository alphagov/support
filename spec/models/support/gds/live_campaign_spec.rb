require "rails_helper"

module Support
  module GDS
    describe LiveCampaign do
      def as_str(date)
        date.strftime("%d-%m-%Y")
      end

      subject {
        LiveCampaign.new(title: "Test Title", proposed_url: "example.campaign.gov.uk",
                         description: "Test description", time_constraints: "Time constraints",
                         reason_for_dates: "Reason for dates")
      }

      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:description) }
      it { should allow_value("example.campaign.gov.uk").for(:proposed_url) }
      it { should !allow_value("text").for(:proposed_url) }
    end
  end
end
