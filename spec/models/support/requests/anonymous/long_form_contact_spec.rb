require 'rails_helper'
require 'support/requests/anonymous/long_form_contact'

module Support
  module Requests
    module Anonymous
      describe LongFormContact do
        it "defaults the requester email to the anonymous email" do
          expect(LongFormContact.new.requester.email).to eq(ZENDESK_ANONYMOUS_TICKETS_REQUESTER_EMAIL)
        end

        it "has a valid default requester" do
          expect(LongFormContact.new.requester).to be_valid
        end
      end
    end
  end
end
