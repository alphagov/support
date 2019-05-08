module Facets
  class BasePresenter
    attr_reader :raw_data

    def initialize(raw_data)
      @raw_data = raw_data
    end

    def title
      raw_data["title"]
    end

    def details
      raw_data.fetch("details", {})
    end

    def links
      raw_data.fetch("links", {})
    end
  end
end
