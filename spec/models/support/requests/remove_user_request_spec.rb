require 'rails_helper'

module Support
  module Requests
    describe RemoveUserRequest do
      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:user_name) }
      it { should validate_presence_of(:user_email) }

      it { should allow_value("ab@c.com").for(:user_email) }
      it { should_not allow_value("ab").for(:user_email) }

      it { should allow_value("was fired").for(:reason_for_removal) }

      it "allows time constraints" do
        request = RemoveUserRequest.new(time_constraint: double("time constraint", valid?: true)).
          tap(&:valid?)

        expect(request.time_constraint).to_not be_nil
        expect(request).to have(0).errors_on(:time_constraint)
      end
    end
  end
end
