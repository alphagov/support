require 'spec_helper'

module Support
  module Requests
    describe LiveCampaignRequest do
      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:live_campaign) }
    end
  end
end
