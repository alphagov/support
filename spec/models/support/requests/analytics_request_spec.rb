require 'spec_helper'

module Support
  module Requests
    describe AnalyticsRequest do
      it { should validate_presence_of(:requester) }

      it 'fails validation if there is no request type' do
        expect(subject.valid?).to be false
        expect(subject.errors[:base]).to include 'Please enter details for at least one type of request'
      end
    end
  end
end
