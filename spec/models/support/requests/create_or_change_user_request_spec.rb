require 'spec_helper'
require 'support/requests/create_or_change_user_request'

module Support
  module Requests
    describe CreateOrChangeUserRequest do
      def request(options = {})
        CreateOrChangeUserRequest.new(options).tap(&:valid?)
      end

      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:requested_user) }
      it { should validate_presence_of(:user_needs) }
      it { should validate_presence_of(:action) }

      it { should allow_value("create_new_user").for(:action) }
      it { should allow_value("change_user").for(:action) }
      it { should_not allow_value("xxx").for(:action) }

      it { should allow_value("a comment").for(:additional_comments) }

      it "provides action choices" do
        expect(request.action_options).to_not be_empty
      end

      it "provides formatted action" do
        expect(request(action: "create_new_user").formatted_action).to eq("New user account")

        expect(request(action: "create_new_user").for_new_user?).to be_truthy
        expect(request(action: "change_user").for_new_user?).to be_falsey
      end

      it "validates that the requested user is valid" do
        request = request(
          requester: double("user", valid?: true),
          requested_user: double("user", valid?: false)
        )
        expect(request).to have_at_least(1).error_on(:base)
      end
    end
  end
end
