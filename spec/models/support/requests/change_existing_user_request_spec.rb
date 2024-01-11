require "rails_helper"

module Support
  module Requests
    describe ChangeExistingUserRequest do
      def request(options = {})
        described_class.new(options).tap(&:valid?)
      end

      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:requested_user) }

      it { should allow_value("a comment").for(:additional_comments) }

      it "provides formatted action" do
        expect(request.formatted_action).to eq("Change an existing user's account")
      end

      context "#for_new_user?" do
        it "is always false" do
          expect(request.for_new_user?).to be_falsey
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
