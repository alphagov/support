require 'spec_helper'

module Support
  module Requests
    describe CampaignRequest do
      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:campaign) }

      it { should allow_value("a comment").for(:additional_comments) }
    end
  end
end
