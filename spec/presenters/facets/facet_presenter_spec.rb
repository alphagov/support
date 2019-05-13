require 'rails_helper'

RSpec.describe Facets::FacetPresenter do
  let(:raw_data) do
    {
      "title" => "Facet 1",
      "details" => { "key" => "facet_1" },
      "links" => {
        "facet_values" => [
          { "title" => "Facet value 1" },
        ]
      }
    }
  end

  subject(:instance) { described_class.new(raw_data) }

  describe "facet attributes" do
    it "exposes title and key" do
      expect(instance.title).to eq(raw_data["title"])
      expect(instance.key).to eq(raw_data["details"]["key"])
    end
  end

  describe "facet_values" do
    it "presents facet values" do
      expect(instance.facet_values.first).to be_a(Facets::FacetValuePresenter)
    end
  end
end
