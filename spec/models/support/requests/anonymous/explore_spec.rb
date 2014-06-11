require 'rails_helper'
require 'support/requests/anonymous/explore'

module Support
  module Requests
    module Anonymous
      describe Explore do
        it { should validate_presence_of(:by_url) }

        it { should allow_value("https://www.gov.uk/test").for(:by_url) }
        it { should_not allow_value("https:aaaa").for(:by_url).with_message(/must be a valid URL/) }

        it "works out the path from the URL" do
          expect(Explore.new(by_url: "https://www.gov.uk/some-path").path).to eq("/some-path")
        end
      end
    end
  end
end
