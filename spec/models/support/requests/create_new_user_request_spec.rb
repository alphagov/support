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

      it { should_not allow_values(nil, "").for(:whitehall_training) }
      it {
        should validate_inclusion_of(:whitehall_training)
          .in_array(%w[whitehall_training_required_none whitehall_training_required_press_officer whitehall_training_required_standard whitehall_training_completed])
          .with_message("Select if the user needs training or access to Whitehall Publisher")
      }

      it { should_not allow_values(nil, "").for(:access_to_other_publishing_apps) }
      it {
        should validate_inclusion_of(:access_to_other_publishing_apps)
          .in_array(%w[whitehall_training_additional_apps_access_no whitehall_training_additional_apps_access_yes])
          .with_message("Select if the user needs access to other publishing apps")
      }

      context "when access to other publishing apps is required" do
        before { subject.access_to_other_publishing_apps = "whitehall_training_additional_apps_access_yes" }

        it { should validate_presence_of(:additional_comments).with_message("List which publishing applications and permissions the user needs") }
      end

      context "when access to other publishing apps is not required" do
        before { subject.access_to_other_publishing_apps = "whitehall_training_additional_apps_access_no" }

        it { should_not validate_presence_of(:additional_comments) }
      end

      it "provides formatted action" do
        expect(request.formatted_action).to eq("Create a new user account")
      end

      describe "#formatted_whitehall_training_option" do
        it "returns the human readable name for the no training option" do
          request = described_class.new(whitehall_training: "whitehall_training_required_none")
          expect(request.formatted_whitehall_training_option).to eq "No, the user does not need to draft or publish content on Whitehall Publisher"
        end

        it "returns the human readable name for the press officer training option" do
          request = described_class.new(whitehall_training: "whitehall_training_required_press_officer")
          expect(request.formatted_whitehall_training_option).to eq "Yes, they need Writing and Publishing on GOV.UK for press officers training"
        end

        it "returns the human readable name for the standard training option" do
          request = described_class.new(whitehall_training: "whitehall_training_required_standard")
          expect(request.formatted_whitehall_training_option).to eq "Yes, they need Writing and Publishing on GOV.UK training"
        end

        it "returns the human readable name for the completed training option" do
          request = described_class.new(whitehall_training: "whitehall_training_completed")
          expect(request.formatted_whitehall_training_option).to eq "They’ve completed training and need a Production account to access Whitehall Publisher"
        end
      end

      describe "#formatted_access_to_other_publishing_apps_option" do
        it "returns the human readable name for the access option" do
          request = described_class.new(access_to_other_publishing_apps: "whitehall_training_additional_apps_access_yes")
          expect(request.formatted_access_to_other_publishing_apps_option).to eq "Yes, the user needs access to the applications and permissions listed below"
        end

        it "returns the human readable name for the no access option" do
          request = described_class.new(access_to_other_publishing_apps: "whitehall_training_additional_apps_access_no")
          expect(request.formatted_access_to_other_publishing_apps_option).to eq "No, the user does not need access to any other publishing application"
        end
      end
    end
  end
end
