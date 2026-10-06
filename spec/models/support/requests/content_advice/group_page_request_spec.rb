require "rails_helper"

module Support
  module Requests
    describe ContentAdvice::GroupPageRequest do
      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:group_name) }
      it { should validate_presence_of(:purpose) }
      it { should validate_presence_of(:user_needs_evidence) }
      it { should validate_presence_of(:contact_reason) }
      it { should validate_presence_of(:deadline) }
    end
  end
end
