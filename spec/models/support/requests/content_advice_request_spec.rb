require 'spec_helper'
require 'support/requests/content_advice_request'

module Support
  module Requests
    describe ContentAdviceRequest do
      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:details) }
      it { should allow_value("xxx").for(:title) }
      it { should allow_value("xxx").for(:urls) }

      it { should allow_value("xxx").for(:contact_number) }

      def as_str(date)
        date.strftime("%d-%m-%Y")
      end
    end
  end
end
