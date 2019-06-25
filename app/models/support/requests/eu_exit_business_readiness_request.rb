require 'active_support/core_ext'

module Support
  module Requests
    class EuExitBusinessReadinessRequest < Request
      attr_accessor :type, :url, :explanation, :sector, :organisation_activity,
                    :employing_eu_citizens, :personal_data, :intellectual_property,
                    :funding_schemes, :public_sector_procurement

      TYPE_OPTIONS = [
        "Adding content to the finder",
        "Update to tagging",
        "Removing content from the finder",
      ].freeze

      EU_EXIT_BUSINESS_FINDER_CONTENT_ID = "52435175-82ed-4a04-adef-74c0199d0f46".freeze

      EMPLOYING_EU_CITIZENS_OPTIONS = %w(Yes No).freeze

      validates_presence_of :url

      def sector_options
        grouped_facet_values.fetch("sector_business_area")
      end

      def organisation_activity_options
        grouped_facet_values.fetch("business_activity")
      end

      def personal_data_options
        grouped_facet_values.fetch("personal_data")
      end

      def intellectual_property_options
        grouped_facet_values.fetch("intellectual_property")
      end

      def founding_schemes_options
        grouped_facet_values.fetch("eu_uk_government_funding")
      end

      def public_sector_procurement_options
        grouped_facet_values.fetch("public_sector_procurement")
      end

      def self.label
        "Request updates to content in the EU Exit business readiness finder"
      end

      def self.description
        "Request to add content, update content tags or remove content from the EU Exit business readiness finder."
      end

    private

      def raw_facet_group
        @raw_facet_group ||= RemoteFacetGroupService.new.find(EU_EXIT_BUSINESS_FINDER_CONTENT_ID)
      end

      def grouped_facet_values
        Facets::FacetGroupPresenter.new(raw_facet_group).grouped_facet_values
      end
    end
  end
end
