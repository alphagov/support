require 'rails_helper'
require 'date'
require 'support/requests/anonymous/service_feedback'

module Support
  module Requests
    module Anonymous
      describe ServiceFeedback do
        it { should validate_presence_of(:service_satisfaction_rating) }
        it { should allow_value(nil).for(:details) }
        it { should validate_presence_of(:slug) }

        it { should validate_inclusion_of(:service_satisfaction_rating).in_range(1..5) }
      end
    end
  end
end
