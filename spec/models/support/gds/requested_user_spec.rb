require "rails_helper"

module Support
  module GDS
    describe RequestedUser do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:email) }

      it { should allow_value("ab@c.com").for(:email) }
      it { should_not allow_value("ab").for(:email) }

      it "has organisation accessor" do
        subject.organisation = "Cabinet Office (CO)"
        expect(subject.organisation).to eq("Cabinet Office (CO)")
      end
    end
  end
end
