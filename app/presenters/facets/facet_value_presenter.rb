module Facets
  class FacetValuePresenter < BasePresenter
    def label
      details["label"]
    end

    def value
      details["value"]
    end
  end
end
