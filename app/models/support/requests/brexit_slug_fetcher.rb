require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'

module Support
  module Requests
    class BrexitSlugFetcher < Request
      APPLICATION_NAME = 'Managing Smart Survey Feedback'.freeze
      attr_accessor :slugs, :auth_client
      def initialize(auth_client)
        @auth_client = auth_client
        @slugs = get_taxon_slugs + get_google_sheets_slugs
      end

    private

      def get_taxon_slugs
        uri = URI("https://www.gov.uk/api/search.json?filter_taxons=d7bdaee2-8ea5-460e-b00d-6e9382eb6b61&count=50&fields=description&fields=link&fields=title")
        response = Net::HTTP.get_response(uri)
        JSON.parse(response.body)["results"].map { |page| page["link"] }
      end

      def get_google_sheets_slugs
        service = Google::Apis::SheetsV4::SheetsService.new
        service.client_options.application_name = APPLICATION_NAME
        service.authorization = @auth_client

        spreadsheet_id = "1bFSDYFT5fBpDQTvAeqw4j7QhYXTnFmDuGCLGDwx-wYk"
        range = 'List of documents with facets!A2:A'
        response = service.get_spreadsheet_values(spreadsheet_id, range)

        spreadsheet_id = "1Pzjeae33PQKzekCJfx95VYlNNPH6ePhsQSMFEIrsY5g"
        range = 'Brexit docs!A4:A'
        response2 = service.get_spreadsheet_values(spreadsheet_id, range)

        (response.values.flatten + response2.values.flatten).uniq
      end
    end
  end
end
