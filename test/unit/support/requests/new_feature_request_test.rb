require 'test_helper'
require 'support/requests/new_feature_request'

module Support
  module Requests
    class NewFeatureRequestTest < Test::Unit::TestCase
      should validate_presence_of(:requester)
      should validate_presence_of(:user_need)
      should validate_presence_of(:request_context)

      should allow_value("XXX").for(:title)
    end
  end
end
