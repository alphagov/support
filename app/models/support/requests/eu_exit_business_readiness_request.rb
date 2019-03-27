require 'active_support/core_ext'

module Support
  module Requests
    class EuExitBusinessReadinessRequest < Request
      attr_accessor :type, :url, :explanation, :sector, :business_activity,
        :employing_eu_citizens, :personal_data, :intellectual_property,
        :funding_schemes, :public_sector_procurement, :pinned_content

      TYPE_OPTIONS = {
        "adding content" => "Adding content to the finder",
        "update tagging" => "Update to tagging",
        "removing content" => "Removing content from the finder",
      }.freeze

      PINNED_CONTENT_OPTIONS = {
        "yes" => "Yes",
        "no" => "No",
      }.freeze

      SECTOR_OPTIONS = {
        "all" => "All sectors",
        "accommodation" => "Accommodation",
        "aerospace" => "Aerospace",
        "agriculture" => "Agriculture and forestry (including wholesale)",
        "air-freight-air-passenger-services" => "Air freight and air passenger services",
        "arts-culture-heritage" => "Arts, culture and heritage",
        "automotive" => "Automotive",
        "auxiliary-activities" => "Auxiliary activities",
        "charities" => "Charities",
        "chemicals" => "Chemicals",
        "clothing-consumer-goods" => "Clothing and consumer goods",
        "clothing-consumer-goods-manufacturing" => "Clothing and consumer goods manufacture",
        "construction-contracting" => "Construction",
        "computer-services" => "Digital, technology and computer services",
        "creative-industries" => "Creative industries",
        "defence" => "Defence",
        "education" => "Education",
        "electricity" => "Electricity",
        "electronics-parts-machinery" => "Electronics, parts and machinery",
        "environmental-services" => "Environmental services",
        "financial-services" => "Financial services",
        "fisheries" => "Fisheries (including wholesale)",
        "food-and-drink" => "Food, drink and tobacco (retail and wholesale)",
        "food-drink-tobacco" => "Food, drink and tobacco (processing)",
        "furniture-manufacture" => "Furniture manufacture",
        "gambling" => "Gambling",
        "health-social-care-services" => "Health and social care services",
        "installation-servicing-repair" => "Installation, servicing and repair",
        "insurance" => "Insurance",
        "justice-prisons" => "Justice including prisons",
        "marine" => "Marine",
        "marine-transport" => "Marine transport",
        "broadcasting" => "Media and broadcasting",
        "medical-technology" => "Medical technology",
        "metals-manufacture" => "Metals manufacture",
        "mining" => "Mining",
        "motor-trades" => "Motor trade",
        "non-metal-materials-manufacture" => "Non-metal materials manufacture",
        "nuclear" => "Nuclear",
        "oil-gas-coal" => "Oil, gas and coal",
        "other-advanced-manufacturing" => "Other advanced manufacturing",
        "other-energy" => "Other energy",
        "other-manufacturing" => "Other manufacturing",
        "personal-services" => "Personal services",
        "pharmaceuticals" => "Pharmaceuticals",
        "ports-airports" => "Ports and airports",
        "postal-courier-services" => "Postal and courier services",
        "professional-and-business-services" => "Professional business services",
        "public-administration" => "Public administration",
        "rail" => "Rail",
        "road-passengers-freight" => "Road (passengers and freight)",
        "rail-passenger-freight" => "Rail (passengers and freight)",
        "real-estate-excl-imputed-rent" => "Real estate",
        "repair-of-computers-consumer-goods" => "Repair of computers and consumer goods",
        "research" => "Research",
        "restaurants-bars-catering" => "Restaurants, bars and catering",
        "retail" => "Retail and wholesale (excluding motor trade, food and drink)",
        "space" => "Space",
        "sports-recreation" => "Sports and recreation",
        "telecoms" => "Telecoms and information services",
        "tourism" => "Tourism",
        "veterinary" => "Veterinary",
        "voluntary-community-organisations" => "Voluntary and community organisations",
        "warehouses-services-pipelines" => "Warehouses, services and pipelines",
      }.freeze

      BUSINESS_ACTIVITY_OPTIONS = {
        "products-or-goods" => "Selling products or goods in the UK",
        "buying" => "Buying products or goods from abroad",
        "selling" => "Selling products or goods abroad",
        "other-eu" => "Doing other types of business in the EU",
        "transporting" => "Businesses transporting goods abroad",
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
        "Request to add content, update content tags or remove content from the EU Exit business readiness finder."
      end

      def type_options
        TYPE_OPTIONS.map { |key, value| [value, key] }
      end

      def pinned_content_options
        PINNED_CONTENT_OPTIONS.map { |key, value| [value, key] }
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
