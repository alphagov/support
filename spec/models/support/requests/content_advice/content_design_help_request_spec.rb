require "rails_helper"

module Support
  module Requests
    describe ContentAdvice::ContentDesignHelpRequest do
      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:advice_needed) }
      it { should validate_presence_of(:deadline) }

      context "when the collaborator email is not valid" do
        it "should not allow invalid collaborator emails" do
          subject.requester = Requester.new(name: "Test Requester", email: "test@example.com", collaborator_emails: "invalid-email")

          subject.valid?
          expect(subject.valid?).to eq false
          expect(subject.errors.full_messages).to include "Collaborator emails invalid-email is not a valid email"
        end
      end

      describe "time constraint" do
        subject do
          ContentAdvice::ContentDesignHelpRequest.new(
            requester: Requester.new(name: "Test Requester", email: "test@example.com"),
            title: "My request title",
            advice_needed: "This is the advice I need",
            deadline: deadline.presence,
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
end
