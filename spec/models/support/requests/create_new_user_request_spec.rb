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
      it { should validate_inclusion_of(:access_to_whitehall_publisher).in_array(%w[not_required requires_writer_permission requires_editor_permissions]).with_message("Select if the user needs access to Whitehall Publisher") }

      it { should_not allow_values(nil, "").for(:access_to_other_publishing_apps) }
      it { should validate_inclusion_of(:access_to_other_publishing_apps).in_array(%w[not_required required]).with_message("Select if the user needs access to other publishing apps") }

      it { should allow_value("a comment").for(:additional_comments) }

      it "provides formatted action" do
        expect(request.formatted_action).to eq("Create a new user account")
      end

      it "validates that additional_comments is not blank" do
        request = request(additional_comments: "")
        expect(request).to have_at_least(1).error_on(:additional_comments)
      end

      describe "#formatted_access_to_whitehall_publisher_option" do
        it "returns the human readable name for the chosen options" do
          report = described_class.new(access_to_whitehall_publisher: "not_required")
          expect(report.formatted_access_to_whitehall_publisher_option).to eq "No, the user does not need to draft or publish content on Whitehall publisher"
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
