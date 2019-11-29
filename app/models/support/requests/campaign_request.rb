module Support
  module Requests
    class CampaignRequest < Request
      attr_accessor :campaign
      validates :campaign, presence: true
      validate do |request|
        if request.campaign && !request.campaign.valid?
          errors[:base] << "Campaign details are either not complete or invalid."
        end
      end

      def campaign_attributes=(attr)
        self.campaign = Support::GDS::Campaign.new(attr)
      end

      attr_accessor :additional_comments

      def self.label
        "Request a new campaign"
      end

      def self.description
        "Request GDS support for a new campaign"
      end
    end
  end
end
