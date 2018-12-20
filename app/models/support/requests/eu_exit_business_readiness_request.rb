require 'active_support/core_ext'

module Support
  module Requests
    class EuExitBusinessReadinessRequest < Request
      attr_accessor :type, :url, :sector, :business_activity,
        :employing_eu_citizens, :personal_data, :intellectual_property,
        :funding_schemes, :public_sector_procurement

      TYPE_OPTIONS = {
        "adding content" => "Adding content to the finder",
        "update tagging" => "Update to tagging",
        "removing content" => "Removing content from the finder",
      }.freeze

      SECTOR_OPTIONS = {
        "accommodation-restaurants-and-catering-services" => "Accommodation, restaurants and catering services",
        "aerospace" => "Aerospace",
        "agriculture" => "Agriculture",
        "air-transport-aviation" => "Air transport (aviation)",
        "ancillary-services" => "Ancillary services",
        "animal-health" => "Animal health",
        "automotive" => "Automotive",
        "banking-market-infrastructure" => "Banking, markets and infrastructure",
        "broadcasting" => "Broadcasting",
        "chemicals" => "Chemicals",
        "computer-services" => "Computer services",
        "construction-contracting" => "Construction and contracting",
        "education" => "Education",
        "electricity" => "Electricity",
        "electronics" => "Electronics",
        "environmental-services" => "Environmental services",
        "fisheries" => "Fisheries",
        "food-and-drink" => "Food and drink",
        "furniture-and-other-manufacturing" => "Furniture and other manufacturing",
        "gas-markets" => "Gas markets",
        "imports" => "Imports",
        "imputed-rent" => "Imputed rent",
        "insurance" => "Insurance",
        "land-transport-excl-rail" => "Land transport (excluding rail)",
        "medical-services" => "Medical services",
        "motor-trades" => "Motor trades",
        "oil-and-gas-production" => "Oil and gas production",
        "other-personal-services" => "Other personal services",
        "parts-and-machinery" => "Parts and machinery",
        "pharmaceuticals" => "Pharmaceuticals",
        "post" => "Post",
        "professional-and-business-services" => "Professional and business services",
        "public-administration-and-defence" => "Public administration and defence",
        "rail" => "Rail",
        "real-estate-excl-imputed-rent" => "Real estate (excluding imputed rent)",
        "retail" => "Retail",
        "social-work" => "Social work",
        "steel-and-other-metals-commodities" => "Steel and other metals or commodities",
        "telecoms" => "Telecoms",
        "textiles-and-clothing" => "Textiles and clothing",
        "warehousing-and-support-for-transportation" => "Warehousing and support for transportation",
        "water-transport-maritime-ports" => "Water transport including maritime and ports",
        "wholesale-excl-motor-vehicles" => "Wholesale (excluding motor vehicles)",
      }.freeze

      BUSINESS_ACTIVITY_OPTIONS = {
        "products-or-goods" => "I sell products or goods in the UK",
        "buying" => "I buy products or goods from abroad",
        "selling" => "I sell products or goods abroad",
        "other-eu" => "I do other types of business in the EU",
        "transporting" => "My business transports goods abroad",
      }.freeze

      EMPLOYING_EU_CITIZENS_OPTIONS = {
        "yes" => "Yes",
        "no" => "No",
      }.freeze

      PERSONAL_DATA_OPTIONS = {
        "yes" => "Yes",
        "no" => "No",
      }.freeze

      INTELLECTUAL_PROPERTY_OPTIONS = {
        "copyright" => "Copyright",
        "trademarks" => "Trade Marks",
        "designs" => "Designs",
        "patents" => "Patents",
        "exhaustion-of-rights" => "Exhaustion of Rights",
      }.freeze

      FUNDING_SCHEMES_OPTIONS = {
        "receiving-eu-funding" => "Receiving EU funding",
        "receiving-uk-government-funding" => "Receiving UK government funding",
      }.freeze

      PUBLIC_SECTOR_PROCUREMENT_OPTIONS = {
        "civil-government-contracts" => "Civil government contracts",
        "defence-contracts" => "Defence contracts",
      }.freeze

      validates_presence_of :url

      def self.label
        "Request updates to content in the EU Exit business readiness finder"
      end

      def self.description
        "Request content to be added to the EU Exit business readiness finder."
      end

      def type_options
        TYPE_OPTIONS.map { |key, value| [value, key] }
      end

      def sector_options
        SECTOR_OPTIONS.map { |key, value| [value, key] }
      end

      def business_activity_options
        BUSINESS_ACTIVITY_OPTIONS.map { |key, value| [value, key] }
      end

      def employing_eu_citizens_options
        EMPLOYING_EU_CITIZENS_OPTIONS.map { |key, value| [value, key] }
      end

      def personal_data_options
        PERSONAL_DATA_OPTIONS.map { |key, value| [value, key] }
      end

      def intellectual_property_options
        INTELLECTUAL_PROPERTY_OPTIONS.map { |key, value| [value, key] }
      end

      def funding_schemes_options
        FUNDING_SCHEMES_OPTIONS.map { |key, value| [value, key] }
      end

      def public_sector_procurement_options
        PUBLIC_SECTOR_PROCUREMENT_OPTIONS.map { |key, value| [value, key] }
      end
    end
  end
end
