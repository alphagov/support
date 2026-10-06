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

    describe "time constraint" do
      let(:deadline) { nil }
      subject do
        ContentAdvice::GroupPageRequest.new(
          requester: Requester.new(name: "Test Requester", email: "test@example.com"),
          group_name: "Group Name",
          purpose: "Group Purpose",
          user_needs_evidence: "User needs evidence",
          contact_reason: "Contact reason",
          deadline: deadline,
        )
      end

      context "when there is no deadline" do
        let(:deadline) { "No" }

        it "does not require a time constraint" do
          expect(subject.valid?).to eq true
        end
      end

      context "when there is a deadline" do
        let(:deadline) { "Yes" }

        it "does require a time constraint" do
          expect(subject.valid?).to eq false
          expect(subject.errors.full_messages).to include "Needed by date can't be blank"
          expect(subject.errors.full_messages).to include "Time constraint reason can't be blank"
        end
      end
    end
  end
end
