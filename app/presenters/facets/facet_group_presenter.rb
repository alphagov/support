module Facets
  class FacetGroupPresenter < BasePresenter
    def name
      details["name"]
    end

    def facets
      expanded_links.fetch("facets", []).map do |facet_data|
        Facets::FacetPresenter.new(facet_data)
      end
    end

    def grouped_facet_values
      array = facets.map do |f|
        [f.key, f.facet_values.map(&:label)]
      end
      array.to_h
    end

  private

    def expanded_links
      raw_data.fetch("expanded_links", {})
    end
  end
end
