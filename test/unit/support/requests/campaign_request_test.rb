require 'test_helper'
require 'support/requests/campaign_request'

module Support
  module Requests
    class CampaignRequestTest < Test::Unit::TestCase
      should validate_presence_of(:requester)
      should validate_presence_of(:campaign)

      should allow_value("a comment").for(:additional_comments)
    end
  end
end