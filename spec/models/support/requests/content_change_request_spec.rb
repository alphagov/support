require 'spec_helper'
require 'support/requests/content_change_request'

module Support
  module Requests
    describe ContentChangeRequest do
      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:details_of_change) }

      it { should validate_presence_of(:request_context) }

      it { should allow_value("xxxx").for(:title) }
      it { should allow_value(nil).for(:title) }

      it { should allow_value("https://www.gov.uk").for(:url) }
      it { should allow_value("https://www.gov.uk/A\nhttps://www.gov.uk/A").for(:related_urls) }

      it "allows time constraints" do
        request =
          ContentChangeRequest.new(time_constraint: double("time constraint", valid?: true)).
          tap(&:valid?)

        expect(request).to have(0).errors_on(:time_constraint)
      end
    end
  end
end
