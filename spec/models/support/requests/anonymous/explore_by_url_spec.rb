require 'rails_helper'
require 'support/requests/anonymous/explore'

module Support
  module Requests
    module Anonymous
      describe ExploreByUrl do
        it { should validate_presence_of(:url) }

        it { should allow_value("https://www.gov.uk/test").for(:url) }
        it { should_not allow_value("https:aaaa").for(:url).with_message(/must be a valid URL/) }

        it "works out the path to redirect to from the URL" do
          expect(ExploreByUrl.new(url: "https://www.gov.uk/some-path").redirect_path).
            to eq("/anonymous_feedback?path=%2Fsome-path")
        end

        it "can extract the path from a valid URL" do
          [
            "https://www.gov.uk/abc",
            "http://www.gov.uk/abc",
          ].each {|url| expect(extracted_path_from(url)).to eq("/abc")}
        end

        it "can extract the path from a URL with a malformed protocol" do
          [
            "http:///www.gov.uk/abc",
            "http//:www.gov.uk/abc",
            "http/:www.gov.uk/abc",
            "http:/www.gov.uk/abc",
          ].each {|url| expect(extracted_path_from(url)).to eq("/abc")}
        end

        it "can extract the path from short hand URLs" do
          [
            "www.gov.uk/abc",
            "gov.uk/abc",
            "/abc",
            "abc",
          ].each {|url| expect(extracted_path_from(url)).to eq("/abc")}
        end

        def extracted_path_from(url)
          ExploreByUrl.new(url: url).path_from_url
        end
      end
    end
  end
end
