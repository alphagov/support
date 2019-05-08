module Facets
  class FacetPresenter < BasePresenter
    def key
      details["key"]
    end

    def facet_values
      links.fetch("facet_values", []).map do |facet_value_data|
        Facets::FacetValuePresenter.new(facet_value_data)
      end
    end
  end
end
