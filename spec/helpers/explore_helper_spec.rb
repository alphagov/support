require 'rails_helper'
require "gds_api/support_api"
require 'gds_api/test_helpers/support_api'

describe ExploreHelper, type: :helper do
  include ExploreHelper
  include GdsApi::TestHelpers::SupportApi

  context "#parse_organisations" do
    before { stub_support_api_organisations_list }

    it "parses the organisations into a [name, slug] list" do
      api_response_org_list = support_api.organisations_list
      result = parse_organisations(api_response_org_list)
      expect(result).to eq([["Cabinet Office (CO)", "cabinet-office"], ["Government Digital Service (GDS)", "gds"]])
    end
  end

  context "#parse_doctypes" do
    before { stub_support_api_document_type_list }

    it "parses the doctypes into a [title, doctype] list" do
      api_response_document_type_list = support_api.document_type_list
      result = parse_doctypes(api_response_document_type_list)
      expect(result).to eq([["Case Study", "case_study"], ["Detailed Guide", "detailed_guide"], ["Smart Answer", "smart_answer"]])
    end
  end

  def support_api
    GdsApi::SupportApi.new(Plek.find("support-api"))
  end
end
