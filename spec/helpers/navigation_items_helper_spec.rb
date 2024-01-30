require "rails_helper"

describe NavigationItemsHelper, type: :helper do
  context "#navigation_items" do
    let(:params) { {} }

    before do
      allow(self).to receive(:params).and_return(params)
    end

    context "when the user is signed in" do
      let(:current_user) { build(:user, name: "Jean Dupont") }

      before do
        allow(self).to receive(:current_user).and_return(current_user)
      end

      it "returns list of default navigation items" do
        expect(navigation_items).to include(
          hash_including(text: "Home", active: false),
          hash_including(text: "GOV.UK Zendesk", active: false),
          hash_including(text: "Switch app", active: false),
          hash_including(text: "Jean Dupont", active: false),
          hash_including(text: "Sign out", active: false),
        )
      end

      context "when user is viewing home page" do
        let(:params) { { controller: "support", action: "landing" } }

        it "returns list with active Home link" do
          expect(navigation_items).to include(
            hash_including(text: "Home", active: true),
          )
        end
      end

      context "when user can read anonymous feedback" do
        before do
          allow(current_user).to receive(:can?).with(:read, :anonymous_feedback).and_return(true)
        end

        it "returns list including link to Feedback explorer" do
          expect(navigation_items).to include(
            hash_including(text: "Feedback explorer"),
          )
        end

        context "when user is viewing Feedback explorer page" do
          let(:params) { { controller: "anonymous_feedback/explore", action: "new" } }

          it "returns list with active Feedback explorer link" do
            expect(navigation_items).to include(
              hash_including(text: "Feedback explorer", active: true),
            )
          end
        end
      end
    end

    context "when the user is not signed in" do
      before do
        allow(self).to receive(:current_user).and_return(nil)
      end

      it "returns empty array" do
        expect(navigation_items).to be_empty
      end
    end
  end
end
