require 'support/requests/anonymous/explore'

module Support
  module Requests
    module Anonymous
      class ExploreTest < Test::Unit::TestCase
        should validate_presence_of(:by_url)

        should allow_value("https://www.gov.uk/test").for(:by_url)
        should_not allow_value("https:aaaa").for(:by_url).with_message(/must be a valid URL/)

        should "work out the path from the URL" do
          assert_equal "/some-path", Explore.new(by_url: "https://www.gov.uk/some-path").path
        end
      end
    end
  end
end
