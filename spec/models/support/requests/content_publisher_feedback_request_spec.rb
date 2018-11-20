require 'spec_helper'

module Support
  module Requests
    describe ContentPublisherFeedbackRequest do
      def request(options = {})
        ContentPublisherFeedbackRequest.new(options).tap(&:valid?)
      end

      it { should validate_presence_of(:feedback_type) }
      it { should validate_presence_of(:feedback_details) }

      it { should allow_value("accessibility or usability").for(:feedback_type) }
      it { should allow_value("working unexpectedly").for(:feedback_type) }
      it { should allow_value("helpful feature").for(:feedback_type) }
      it { should allow_value("other").for(:feedback_type) }
      it { should_not allow_value("xxx").for(:feedback_type) }

      it { should allow_value("").for(:impact_on_work) }

      it "provides type of change choices" do
        expect(request.feedback_type_options).to_not be_empty
      end
    end
  end
end
