require 'rails_helper'

module Support
  module Requests
    module Anonymous
      describe ExploreByMultiplePaths do
        include ActionDispatch::TestProcess
        it { should allow_value('https://www.gov.uk/test').for(:list_of_urls) }
        it { should allow_value('/vat-rates, https://www.gov.uk/bank-holidays, /guidance/').for(:list_of_urls) }
        it { should allow_value(fixture_file_upload("#{Rails.root}/spec/fixtures/list_of_urls.csv", 'text/plain')).for(:uploaded_list) }
        it { should_not allow_value('https:aaaa').for(:list_of_urls).with_message("https:aaaa is not valid. Must contain only valid URLs") }
        it { should_not allow_value('/vat-rates, https:aaaa, /guidance/').for(:list_of_urls).with_message("https:aaaa is not valid. Must contain only valid URLs") }
        it { should_not allow_value(fixture_file_upload("#{Rails.root}/spec/fixtures/list_of_bad_urls.csv", 'text/plain')).for(:uploaded_list).with_message("https:aaaa is not valid. Must contain only valid URLs") }

        it 'raises an error if `uploaded_list` and `list_of_urls` are blank' do
          @explore_by_multiple_paths = ExploreByMultiplePaths.new(uploaded_list: nil, list_of_urls: nil)
          @explore_by_multiple_paths.valid?
          expect(@explore_by_multiple_paths.errors[:base]).to include("Please provide a valid list of urls.")
        end

        it "works out the path to redirect to from the URL" do
          expect(ExploreByMultiplePaths.new(list_of_urls: "https://www.gov.uk/some-path").redirect_path).
            to eq("/anonymous_feedback?paths=%2Fsome-path")
        end

        it "works out the path to redirect to from the URL" do
          expect(ExploreByMultiplePaths.new(list_of_urls: "https://www.gov.uk/some-path, /vat-rates").redirect_path).
            to eq("/anonymous_feedback?paths=%2Fsome-path%2C+%2Fvat-rates")
        end

        it "works out the path to redirect to from the uploaded list of URLs" do
          expect(ExploreByMultiplePaths.new(uploaded_list: fixture_file_upload("#{Rails.root}/spec/fixtures/list_of_urls.csv", 'text/plain')).redirect_path).
            to eq("/anonymous_feedback?paths=%2Fvat-rates%2C+%2Fdone%2C+%2Fvehicle-tax")
        end

        it "can extract the path from a valid URL" do
          list_of_urls = "https://www.gov.uk/abc, http://www.gov.uk/abc"
          expect(extracted_paths_from(list_of_urls: list_of_urls)).to eq("/abc")
        end

        it "can extract the path from an uploaded list of valid URLs" do
          uploaded_list = fixture_file_upload("#{Rails.root}/spec/fixtures/list_of_valid_urls.csv", 'text/plain')
          expect(extracted_paths_from(uploaded_list: uploaded_list)).to eq("/abc")
        end

        it "can extract the path from a URL with a malformed protocol" do
          list_of_urls = "http:///www.gov.uk/abc, http//:www.gov.uk/abc, http/:www.gov.uk/abc, http:/www.gov.uk/abc"
          expect(extracted_paths_from(list_of_urls: list_of_urls)).to eq("/abc")
        end

        it "can extract the path from an uploaded list of URLs with a malformed protocol" do
          uploaded_list = fixture_file_upload("#{Rails.root}/spec/fixtures/list_of_urls_with_malformed_protocol.csv", 'text/plain')
          expect(extracted_paths_from(uploaded_list: uploaded_list)).to eq("/abc")
        end

        it "can extract the path from short hand URLs" do
          list_of_urls = "www.gov.uk/abc, gov.uk/abc, /abc, abc"
          expect(extracted_paths_from(list_of_urls: list_of_urls)).to eq("/abc")
        end

        it "can extract the path from uploaded list of short hand URLs" do
          uploaded_list = fixture_file_upload("#{Rails.root}/spec/fixtures/list_of_shorthand_urls.csv", 'text/plain')
          expect(extracted_paths_from(uploaded_list: uploaded_list)).to eq("/abc")
        end

        def extracted_paths_from(list_of_urls: nil, uploaded_list: nil)
          ExploreByMultiplePaths.new(list_of_urls: list_of_urls, uploaded_list: uploaded_list).paths_from_urls
        end
      end
    end
  end
end
