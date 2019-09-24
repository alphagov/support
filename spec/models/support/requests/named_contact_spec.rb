require "rails_helper"

module Support
  module Requests
    describe NamedContact do
      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:details) }
      it { should allow_value("abc").for(:referrer) }
      it { should allow_value("abc").for(:user_agent) }

      it { should allow_value(true).for(:javascript_enabled) }
      it { should allow_value(false).for(:javascript_enabled) }
      it { should_not allow_value("abc").for(:javascript_enabled) }

      it "provides the path if a GOV.UK link is specified" do
        expect(NamedContact.new(link: "https://www.gov.uk/abc").govuk_link_path).to eq("/abc")
        expect(NamedContact.new(link: "https://www.google.co.uk/ab").govuk_link_path).to be_nil
        expect(NamedContact.new(link: nil).govuk_link_path).to be_nil
      end
    end
  end
end
