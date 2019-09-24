require "rails_helper"

module Support
  module Requests
    describe ChangesToPublishingAppsRequest do
      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:user_need) }

      it { should allow_value("XXX").for(:title) }
    end
  end
end
