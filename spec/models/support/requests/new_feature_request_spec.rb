require 'spec_helper'
require 'support/requests/new_feature_request'

module Support
  module Requests
    describe NewFeatureRequest do
      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:user_need) }
      it { should validate_presence_of(:request_context) }

      it { should allow_value("XXX").for(:title) }
    end
  end
end
