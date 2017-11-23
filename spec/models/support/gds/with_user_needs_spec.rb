require 'rails_helper'

module Support
  module GDS
    class TestModelWithUserNeeds
      include ActiveModel::Model
      include WithUserNeeds
    end

    describe TestModelWithUserNeeds do
      def request(attr = {})
        TestModelWithUserNeeds.new(attr)
      end

      it "knows if it's related to inside government or not" do
        expect(request(user_needs: "writer")).to be_inside_government_related
        expect(request(user_needs: "editor")).to be_inside_government_related
        expect(request(user_needs: "managing_editor")).to be_inside_government_related
      end

      describe "formatted_user_needs" do
        context "for a Whitehall user account" do
          it "returns the long text of the user need" do
            expect(request(user_needs: "writer").formatted_user_needs).
              to eq("Writer - can create content")
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
              expect(request(maslow: "1").formatted_user_needs).
                to eq("Access to Maslow database of user needs")

              expect(request(mainstream_changes: "1").formatted_user_needs).
                  to eq("Request changes to your organisation’s mainstream content")

              expect(request(become_organisation_admin: "1").formatted_user_needs).
                  to eq("Request permission to be your organisation admin")

              expect(request(become_super_organisation_admin: "1").formatted_user_needs).
                  to eq("Request permission to be a super organisation admin")
            end
          end

          context "when several are ticked" do
            it "returns the long text of the permissions, with one permission per line" do
              expect(request(mainstream_changes: "1", maslow: "1").formatted_user_needs).
                to eq("Request changes to your organisation’s mainstream content\nAccess to Maslow database of user needs")
            end
          end

          context "when other is filled in" do
            it "returns the text of the other field" do
              expect(request(other_details: "special permission request").formatted_user_needs).
                to eq("Other: special permission request")
            end
            context "and when another permission is ticked" do
              it "returns long text of the permissions and the text of the other field" do
                expect(request(mainstream_changes: "1", other_details: "special permission request").formatted_user_needs).
                  to eq("Request changes to your organisation’s mainstream content\nOther: special permission request")
              end
            end
          end
        end
      end
    end
  end
end
