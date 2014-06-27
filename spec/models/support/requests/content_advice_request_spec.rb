require 'spec_helper'
require 'support/requests/content_advice_request'

module Support
  module Requests
    describe ContentAdviceRequest do
      it { should validate_presence_of(:requester) }
      it { should allow_value("xxx").for(:title) }

      it { should validate_presence_of(:nature_of_request) }

      its(:nature_of_request_options) { is_expected.to have_exactly(3).items }
    end
  end
end
