require "rails_helper"

module Support
  module Requests
    describe AccountsPermissionsAndTrainingRequest do
      def request(options = {})
        described_class.new(options).tap(&:valid?)
      end

      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:requested_user) }
      it { should validate_presence_of(:action) }

      it { should allow_value("create_new_user").for(:action) }
      it { should allow_value("change_user").for(:action) }
      it { should_not allow_value("unsuspend_user").for(:action) }
      it { should_not allow_value("xxx").for(:action) }

      it { should allow_value("a comment").for(:additional_comments) }

      it "provides action options" do
        expect(request.action_options).to_not be_empty
      end

      it "provides formatted action" do
        expect(request(action: "create_new_user").formatted_action).to eq("Create a new user account (non-Whitehall only)")
        expect(request(action: "change_user").formatted_action).to eq("Change an existing user's account")
      end

      context "#for_new_user?" do
        it "is true when the action is `create_new_user`" do
          expect(request(action: "create_new_user").for_new_user?).to be_truthy
        end

        it "is false for other actions" do
          expect(request(action: "change_user").for_new_user?).to be_falsey
          expect(request(action: "not_a_valid_action").for_new_user?).to be_falsey
        end
      end

      it "validates that the requested user is valid" do
        request = request(
          requester: double("user", valid?: true),
          requested_user: double("user", valid?: false),
        )
        expect(request).to have_at_least(1).error_on(:base)
      end

      it "knows if it's related to inside government or not" do
        expect(request(user_needs: "writer")).to be_inside_government_related
        expect(request(user_needs: "editor")).to be_inside_government_related
        expect(request(user_needs: "managing_editor")).to be_inside_government_related
      end

      describe "formatted_user_needs" do
        context "for a Whitehall user account" do
          it "returns the long text of the user need" do
            expect(request(user_needs: "writer").formatted_user_needs)
              .to eq("Writer - can create content")

            expect(request(user_needs: "editor").formatted_user_needs)
              .to eq("Editor - can create, review and publish content")

            expect(request(user_needs: "managing_editor").formatted_user_needs)
              .to eq("Managing editor - can create, review and publish content, and has admin rights")
          end
        end

        context "when nothing is selected" do
          it "returns an empty string" do
            expect(request(mainstream_changes: "0", maslow: "0").formatted_user_needs).to be_blank
          end

          it "fails validation" do
            expect(request(mainstream_changes: "0", maslow: "0")).to_not be_valid
          end
        end

        context "for other permissions" do
          context "when one is ticked" do
            it "returns the long text of the permission" do
              expect(request(maslow: "1").formatted_user_needs)
                .to eq("Access to Maslow database of user needs")

              expect(request(mainstream_changes: "1").formatted_user_needs)
                  .to eq("Request changes to your organisation’s mainstream content")

              expect(request(become_organisation_admin: "1").formatted_user_needs)
                  .to eq("Request permission to be your organisation admin")

              expect(request(become_super_organisation_admin: "1").formatted_user_needs)
                  .to eq("Request permission to be a super organisation admin")
            end
          end

          context "when several are ticked" do
            it "returns the long text of the permissions, with one permission per line" do
              expect(request(mainstream_changes: "1", maslow: "1").formatted_user_needs)
                .to eq("Request changes to your organisation’s mainstream content\nAccess to Maslow database of user needs")
            end
          end

          context "when other is filled in" do
            it "returns the text of the other field" do
              expect(request(other_details: "special permission request").formatted_user_needs)
                .to eq("Other: special permission request")
            end

            context "and when another permission is ticked" do
              it "returns long text of the permissions and the text of the other field" do
                expect(request(mainstream_changes: "1", other_details: "special permission request").formatted_user_needs)
                  .to eq("Request changes to your organisation’s mainstream content\nOther: special permission request")
              end
            end
          end
        end

        context "for new account permissions" do
          context "when one is ticked" do
            it "returns the name of the application" do
              expect(request(manuals_publisher: "1").formatted_user_needs)
                .to eq("Manuals Publisher")

              expect(request(specialist_publisher: "1").formatted_user_needs)
                  .to eq("Specialist Publisher")

              expect(request(travel_advice_publisher: "1").formatted_user_needs)
                  .to eq("Travel Advice Publisher (FCO)")

              expect(request(content_data: "1").formatted_user_needs)
                  .to eq("Content Data")

              expect(request(feedex: "1").formatted_user_needs)
              .to eq("Feedex")
            end
          end

          context "when several are ticked" do
            it "returns the name of each application, with one per line" do
              expect(request(manuals_publisher: "1", travel_advice_publisher: "1").formatted_user_needs)
                .to eq("Manuals Publisher\nTravel Advice Publisher (FCO)")
            end
          end
        end
      end
    end
  end
end
