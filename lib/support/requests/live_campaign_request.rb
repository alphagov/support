require 'support/requests/request'
require 'support/gds/live_campaign'

module Support
  module Requests
    class LiveCampaignRequest < Request
      attr_accessor :live_campaign
      validates_presence_of :live_campaign
      validate do |request|
        if request.live_campaign && !request.live_campaign.valid?
          errors[:base] << "Campaign details are either not complete or invalid."
        end
      end

      def live_campaign_attributes=(attr)
        self.live_campaign = Support::GDS::LiveCampaign.new(attr)
      end

      def self.label
        "Support for live campaign"
      end

      def self.description
        "Request GDS support for a live campaign"
      end
    end
  end
end
