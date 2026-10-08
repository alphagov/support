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
      it { should validate_presence_of(:associated_organisations) }
      it { should validate_presence_of(:deadline) }

      it { should validate_inclusion_of(:logo_type).in_array(described_class::LOGO_TYPES) }
      it { should validate_inclusion_of(:organisation_status).in_array(described_class::ORG_STATUSES) }
      it { should validate_inclusion_of(:organisation_type).in_array(described_class::ORG_OPTIONS.pluck(:type)) }

      it { should allow_value("text@example.com").for(:alternative_format_email) }
      it { should_not allow_value("invalid-email-address").for(:alternative_format_email) }

      it { should allow_value("test-person@example.com").for(:govuk_lead_email) }
      it { should_not allow_value("invalid-email-address").for(:govuk_lead_email) }

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

      context "when the collaborator email is not valid" do
        it "should not allow invalid collaborator emails" do
          subject.requester = Requester.new(name: "Test Requester", email: "test@example.com", collaborator_emails: "invalid-email")

          subject.valid?
          expect(subject.valid?).to eq false
          expect(subject.errors.full_messages).to include "Collaborator emails invalid-email is not a valid email"
        end
      end
    end

    describe "time constraint" do
      subject do
        ContentAdvice::OrganisationPageRequest.new(
          requester: Requester.new(name: "Test Requester", email: "test@example.com"),
          organisation_name: "My new org",
          logo_type: "Single identity system",
          sis_logo_format: "stacked SIS text",
          parent_organisation: "My parent organisation",
          organisation_type: "Ministerial department",
          organisation_status: "Coming soon",
          govuk_lead_name: "Test Person",
          govuk_lead_email: "test-person@example.com",
          alternative_format_email: "alt-format@example.com",
          associated_organisations: "My supporting org",
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
