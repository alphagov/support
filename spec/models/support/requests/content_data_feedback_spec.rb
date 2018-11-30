require 'rails_helper'

module Support
  module Requests
    describe ContentDataFeedback do
      it { should validate_presence_of(:feedback_type) }
      it { should validate_presence_of(:feedback_details) }

      it { should allow_value("accessibility or usability").for(:feedback_type) }
      it { should allow_value("working unexpectedly").for(:feedback_type) }
      it { should allow_value("helpful feature").for(:feedback_type) }
      it { should allow_value("other").for(:feedback_type) }
      it { should_not allow_value("xxx").for(:feedback_type) }

      it { should allow_value("").for(:impact_on_work) }
    end
  end
end
