require "rails_helper"

module Support
  module Requests
    describe CreateNewUserRequest do
      def request(options = {})
        described_class.new(options).tap(&:valid?)
      end

      it { should validate_presence_of(:requester) }

      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:email) }

      it { should allow_value("ab@c.com").for(:email) }
      it { should_not allow_value("ab").for(:email) }

      it { should_not allow_values(nil, "").for(:access_to_whitehall_publisher) }
      it { should validate_inclusion_of(:access_to_whitehall_publisher).in_array(%w[not_required publishing_training_required_press_officer publishing_training_required_standard publishing_training_completed]).with_message("Select if the user needs access to Whitehall Publisher") }

      it { should_not allow_values(nil, "").for(:access_to_other_publishing_apps) }
      it { should validate_inclusion_of(:access_to_other_publishing_apps).in_array(%w[not_required required]).with_message("Select if the user needs access to other publishing apps") }

      context "when access to other publishing apps is required" do
        before { subject.access_to_other_publishing_apps = "required" }

        it { should validate_presence_of(:additional_comments).with_message("List which publishing applications and permissions the user needs") }
      end

      context "when access to other publishing apps is not required" do
        before { subject.access_to_other_publishing_apps = "not_required" }

        it { should_not validate_presence_of(:additional_comments) }
      end

      it "provides formatted action" do
        expect(request.formatted_action).to eq("Create a new user account")
      end

      describe "#formatted_access_to_whitehall_publisher_option" do
        it "returns the human readable name for the chosen options" do
          report = described_class.new(access_to_whitehall_publisher: "not_required")
          expect(report.formatted_access_to_whitehall_publisher_option).to eq "No, the user does not need to draft or publish content on Whitehall Publisher"
        end

        it "returns the human readable name for the chosen options" do
          report = described_class.new(access_to_whitehall_publisher: "publishing_training_required_press_officer")
          expect(report.formatted_access_to_whitehall_publisher_option).to eq "Yes, they need Writing and Publishing on GOV.UK for press officers training"
        end

        it "returns the human readable name for the chosen options" do
          report = described_class.new(access_to_whitehall_publisher: "publishing_training_required_standard")
          expect(report.formatted_access_to_whitehall_publisher_option).to eq "Yes, they need Writing and Publishing on GOV.UK training"
        end

        it "returns the human readable name for the chosen options" do
          report = described_class.new(access_to_whitehall_publisher: "publishing_training_completed")
          expect(report.formatted_access_to_whitehall_publisher_option).to eq "They’ve completed training and need a Production account to access Whitehall Publisher"
        end
      end

      describe "#formatted_access_to_other_publishing_apps_option" do
        it "returns the human readable name for the chosen options" do
          report = described_class.new(access_to_other_publishing_apps: "not_required")
          expect(report.formatted_access_to_other_publishing_apps_option).to eq "No, the user does not need access to any other publishing application"
        end
      end
    end
  end
end
