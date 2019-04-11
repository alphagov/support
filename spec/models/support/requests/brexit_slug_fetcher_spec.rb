module Support
  module Requests
    describe BrexitSlugFetcher do
      it "does stuff" do
        class FakeSheetsRequester
          def initialize(_auth)
            @service = ["service"]
          end
        end
        govuk_url = "https://www.gov.uk/api/search.json?count=50&fields=title&filter_taxons=d7bdaee2-8ea5-460e-b00d-6e9382eb6b61"
        first_spreadsheet_url = "https://sheets.googleapis.com/v4/spreadsheets/1bFSDYFT5fBpDQTvAeqw4j7QhYXTnFmDuGCLGDwx-wYk/values/List%20of%20documents%20with%20facets!A2:A"
        # second_spreadsheet_url = "sgsdgf"
        # class FakeResponse
        #   attr_reader :values
        #   def initialize
        #     @values = {"one": "/"}
        #   end
        #
        #   # def each_key
        #   #   "this"
        #   # end
        # end

        stub_request(:get, govuk_url).
          to_return(status: 200, body: "{\"results\": []}")
        stub_request(:get, first_spreadsheet_url).
          # to_return(Google::Apis::SheetsV4::ValueRange.new)
          to_return(status: 200, body: JSON.parse("{\"value\": \"vale\"}"))
        # stub_request(:get, second_spreadsheet_url).
        #   to_return(FakeResponse.new)

        slug_fetcher = BrexitSlugFetcher.new("fake_auth_client")
        slug_fetcher.slugs
      end
    end
  end
end
