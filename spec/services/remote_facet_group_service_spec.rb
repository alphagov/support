require "rails_helper"
require "services"
require "remote_facet_group_service"

RSpec.describe RemoteFacetGroupService do
  let(:publishing_api) { Services.publishing_api }

  describe "find" do
    let(:api_response) { double(:response, to_hash: "Yeah!") }
    before do
      allow(publishing_api).to receive(:get_expanded_links).and_return(api_response)
    end

    it "fetches the expanded facet group from the publishing api" do
      result = subject.find("abc-123")
      expect(result).to eq("Yeah!")
      expect(publishing_api).to have_received(:get_expanded_links).with("abc-123")
    end
  end
end
