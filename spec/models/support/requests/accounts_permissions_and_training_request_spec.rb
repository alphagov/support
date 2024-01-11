require "rails_helper"

module Support
  module Requests
    describe AccountsPermissionsAndTrainingRequest do
      def request(options = {})
        described_class.new(options).tap(&:valid?)
      end

      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:requested_user) }
      it { should validate_presence_of(:action) }

      it { should allow_value("create_new_user").for(:action) }
      it { should allow_value("change_user").for(:action) }
      it { should_not allow_value("unsuspend_user").for(:action) }
      it { should_not allow_value("xxx").for(:action) }

      it { should allow_value("a comment").for(:additional_comments) }

      it "provides action options" do
        expect(request.action_options).to_not be_empty
      end

      it "provides formatted action" do
        expect(request(action: "create_new_user").formatted_action).to eq("Create a new user account")
        expect(request(action: "change_user").formatted_action).to eq("Change an existing user's account")
      end

      context "#for_new_user?" do
        it "is true when the action is `create_new_user`" do
          expect(request(action: "create_new_user").for_new_user?).to be_truthy
        end

        it "is false for other actions" do
          expect(request(action: "change_user").for_new_user?).to be_falsey
          expect(request(action: "not_a_valid_action").for_new_user?).to be_falsey
        end
      end

      it "validates that the requested user is valid" do
        request = request(
          requester: double("user", valid?: true),
          requested_user: double("user", valid?: false),
        )
        expect(request).to have_at_least(1).error_on(:base)
      end
    end
  end
end
