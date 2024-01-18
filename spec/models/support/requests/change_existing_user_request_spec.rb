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

      it { should allow_value("a comment").for(:additional_comments) }

      it "provides formatted action" do
        expect(request.formatted_action).to eq("Change an existing user's account")
      end

      it "validates that additional_comments is not blank" do
        request = request(additional_comments: "")
        expect(request).to have_at_least(1).error_on(:additional_comments)
      end
    end
  end
end
