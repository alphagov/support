require 'rails_helper'
require 'support/requests/anonymous/long_form_contact'

module Support
  module Requests
    module Anonymous
      describe LongFormContact do
        it { should validate_presence_of(:details) }
        it { should allow_value("abc").for(:user_agent) }

        it { should allow_value(true).for(:javascript_enabled) }
        it { should allow_value(false).for(:javascript_enabled) }

        it { should allow_value("a" * 2**16).for(:details) }
        it { should_not allow_value("a" * (2**16+1)).for(:details) }

        it { should allow_value("abc").for(:user_specified_url) }
        it { should allow_value(nil).for(:user_specified_url) }

        it "doesn't allow random values for javascript_enabled" do
          expect(LongFormContact.new(javascript_enabled: "abc").javascript_enabled).to be_falsey
        end

        it "defaults the requester email to the anonymous email" do
          expect(LongFormContact.new.requester.email).to eq(ZENDESK_ANONYMOUS_TICKETS_REQUESTER_EMAIL)
        end

        it "has a valid default requester" do
          expect(LongFormContact.new.requester).to be_valid
        end

        it "provides the path if a GOV.UK link is specified" do
          expect(LongFormContact.new(user_specified_url: "https://www.gov.uk/abc").govuk_link_path).to eq("/abc")
          expect(LongFormContact.new(user_specified_url: "https://www.google.co.uk/ab").govuk_link_path).to be_nil
          expect(LongFormContact.new(user_specified_url: nil).govuk_link_path).to be_nil
        end
      end
    end
  end
end
