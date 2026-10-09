require "rails_helper"

module Support
  module Requests
    describe ContentAdvice::OrganisationPageRequest do
      it { should validate_presence_of(:organisation_name) }
      it { should validate_presence_of(:logo_type) }
      it { should validate_presence_of(:parent_organisation) }
      it { should validate_presence_of(:organisation_type) }
      it { should validate_presence_of(:organisation_status) }
      it { should validate_presence_of(:alternative_format_email) }
      it { should validate_presence_of(:govuk_lead_name) }
      it { should validate_presence_of(:govuk_lead_email) }
      it { should validate_presence_of(:deadline) }

      it { should validate_inclusion_of(:logo_type).in_array(described_class::LOGO_TYPES) }
      it { should validate_inclusion_of(:organisation_status).in_array(described_class::ORG_STATUSES) }
      it { should validate_inclusion_of(:organisation_type).in_array(described_class::ORG_TYPES.pluck(:type)) }

      it { should allow_value("text@example.com").for(:alternative_format_email) }
      it { should_not allow_value("invalid-email-address").for(:alternative_format_email) }

      context "when the org has a plain text logo" do
        subject { described_class.new(logo_type: "Plain text", plain_text_logo_format: "stacked plain text", sis_logo_format: "") }
        it { should validate_presence_of(:plain_text_logo_format) }
        it { should_not validate_presence_of(:sis_logo_format) }
        it { should be_plain_text_logo }
        it { should have_attributes(logo_format: "stacked plain text") }
      end

      context "when the org doesn't have a plain text logo" do
        subject { described_class.new(logo_type: "Single identity system", plain_text_logo_format: "", sis_logo_format: "stacked sis text") }
        it { should validate_presence_of(:sis_logo_format) }
        it { should_not validate_presence_of(:plain_text_logo_format) }
        it { should be_sis_logo }
        it { should have_attributes(logo_format: "stacked sis text") }
      end

      context "when the org has a Custom logo" do
        subject { described_class.new(logo_type: "Custom logo") }
        it { should_not validate_presence_of(:plain_text_logo_format) }
        it { should_not validate_presence_of(:sis_logo_format) }
        it { should be_custom_logo }

        it { should validate_presence_of(:gcs_exemption) }
      end

      context "when the org status is exempt from joining" do
        subject { described_class.new(organisation_status: "Exempt from joining") }
        it { should validate_presence_of(:exempt_from_govuk) }
        it { should be_exempt_from_joining }
      end

      context "when the org status is not exempt from joining" do
        subject { described_class.new(organisation_status: "Coming soon") }
        it { should_not validate_presence_of(:exempt_from_govuk) }
        it { should_not be_exempt_from_joining }
      end

      context "when the request has an org name" do
        subject { described_class.new(organisation_name: "My new org") }
        it { should have_attributes(title: "My new org - organisation page request") }
      end

      context "when the org has a plain text logo format" do
        subject { described_class.new(plain_text_logo_format: "Stacked") }
        it { should have_attributes(logo_format: "Stacked") }
      end

      context "when the org has a SIS logo format" do
        subject { described_class.new(sis_logo_format: "Stacked") }
        it { should have_attributes(logo_format: "Stacked") }
      end
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
