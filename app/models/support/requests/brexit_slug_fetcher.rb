require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'yaml'

module Support
  module Requests
    class BrexitSlugFetcher < Request
      attr_accessor :slugs
      def initialize(auth_client)
        @service = SheetsRequester.new(auth_client)
        @slugs = get_taxon_slugs + get_google_sheets_slugs
      end

    private

      def get_taxon_slugs
        uri = URI("#{Plek.new.find('search')}/search.json?filter_taxons=d7bdaee2-8ea5-460e-b00d-6e9382eb6b61&count=50&fields=description&fields=link&fields=title")
        response = Net::HTTP.get_response(uri)
        JSON.parse(response.body)["results"].map { |page| page["link"] }
      end

      def get_google_sheets_slugs
        config = YAML.load_file("config/google_config.yaml")

        spreadsheet_id = config["spreadsheet_id_1"]
        range = 'List of documents with facets!A2:A'
        response = @service.get_sheet_values(spreadsheet_id, range).values.flatten

        spreadsheet_id = config["spreadsheet_id_2"]
        range = 'Brexit docs!A4:A'
        response2 = @service.get_sheet_values(spreadsheet_id, range).values.flatten

        (response + response2).uniq
      end
    end
  end
end
