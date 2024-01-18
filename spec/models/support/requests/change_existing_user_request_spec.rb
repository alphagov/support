require "rails_helper"

module Support
  module Requests
    describe ChangeExistingUserRequest do
      def request(options = {})
        described_class.new(options).tap(&:valid?)
      end

      it { should validate_presence_of(:requester) }

      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:email) }

      it { should allow_value("ab@c.com").for(:email) }
      it { should_not allow_value("ab").for(:email) }

      it { should validate_presence_of(:additional_comments) }

      it "provides formatted action" do
        expect(request.formatted_action).to eq("Change an existing user's account")
      end
    end
  end
end
