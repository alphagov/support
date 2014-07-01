require 'spec_helper'
require 'support/requests/content_advice_request'

module Support
  module Requests
    describe ContentAdviceRequest do
      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:details) }
      it { should allow_value("xxx").for(:title) }
      it { should allow_value("xxx").for(:nature_of_request_details) }
      it { should allow_value("xxx").for(:urls) }

      it { should allow_value(nil).for(:response_needed_by_date) }
      it { should allow_value(as_str(Date.today + 1)).for(:response_needed_by_date) }
      it { should_not allow_value("x").for(:response_needed_by_date) }

      it { should validate_presence_of(:nature_of_request) }
      it { should allow_value("xxx").for(:reason_for_deadline) }
      it { should allow_value("xxx").for(:contact_number) }

      its(:nature_of_request_options) { is_expected.to have_exactly(3).items }

      context "nature of request is 'other'" do
        subject { ContentAdviceRequest.new(nature_of_request: 'other') }

        it { should validate_presence_of(:nature_of_request_details) }
      end

      def as_str(date)
        date.strftime("%d-%m-%Y")
      end
    end
  end
end
