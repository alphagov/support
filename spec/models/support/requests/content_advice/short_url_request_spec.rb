require "rails_helper"

module Support
  module Requests
    describe ContentAdvice::ShortUrlRequest do
      it { should validate_presence_of(:title) }
      it { should validate_presence_of(:destination_page) }
      it { should validate_presence_of(:reason) }
      it { should validate_presence_of(:usage) }
      it { should validate_presence_of(:marketing_message) }
      it { should validate_presence_of(:organisations_using_url) }
      it { should validate_presence_of(:deadline) }
    end

    describe "time constraint" do
      let(:deadline) { nil }
      subject do
        ContentAdvice::ShortUrlRequest.new(
          requester: Requester.new(name: "Test Requester", email: "test@example.com"),
          title: "my ticket",
          destination_page: "/my-short-url",
          reason: "reason",
          usage: "usage",
          marketing_message: "marketing message",
          organisations_using_url: "organisations using url",
          additional_info: "additional info",
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

      context "when the requester collaborator emails are not valid" do
        it "contains a meaningful error message" do
          subject.requester.collaborator_emails = "1234"

          expect(subject.valid?).to eq false
          expect(subject.errors.full_messages).to include "Collaborator emails 1234 is not a valid email"
        end
      end
    end
  end
end
