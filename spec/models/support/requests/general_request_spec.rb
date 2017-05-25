require 'spec_helper'

module Support
  module Requests
    describe GeneralRequest do
      it { should validate_presence_of(:requester) }
      it { should validate_presence_of(:details) }

      it { should allow_value("xxx").for(:title) }

      it { should allow_value("https://www.gov.uk").for(:url) }

      it { should allow_value("a comment").for(:details) }
    end
  end
end
