require 'rails_helper'

RSpec.describe Facets::FacetGroupPresenter do
  let(:raw_data) do
    {
      "content_id" => "abc-123",
      "title" => "Facet group 1",
      "details" => { "name" => "Facet group 1", "description" => "This is facet group 1" },
      "publication_state" => "published",
      "expanded_links" => {
        "facets" => [
          {
            "title" => "Facet 1",
            "details" => { "key" => "facet_1" },
            "links" => {
              "facet_values" => [
                {
                  "details" => { "label" => "Facet value 1" }
                },
                {
                  "details" => { "label" => "Facet value 2" }
                }
              ]
            }
          }
        ]
      }
    }
  end

  subject(:instance) { described_class.new(raw_data) }

  describe "facet group attributes" do
    it "exposes content_id, title, name, description and state" do
      expect(instance.title).to eq(raw_data["title"])
      expect(instance.name).to eq(raw_data["details"]["name"])
    end
  end

  describe "facets" do
    it "presents facets" do
      expect(instance.facets.first).to be_a(Facets::FacetPresenter)
    end
  end

  describe "grouped_facet_values" do
    it "creates a facet values hash" do
      expect(instance.grouped_facet_values).to eq(
        "facet_1" => ["Facet value 1", "Facet value 2"]
      )
    end
  end
end
