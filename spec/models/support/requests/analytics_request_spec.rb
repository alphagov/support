require 'spec_helper'
require 'support/requests/analytics_request'

module Support
  module Requests
    describe AnalyticsRequest do
      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:request_context) }

      it { should validate_presence_of(:needed_report) }
      it { should validate_presence_of(:justification_for_needing_report) }
    end
  end
end
