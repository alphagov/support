require 'active_support/core_ext'

module Support
  module Requests
    class EuExitBusinessReadinessRequest < Request
      attr_accessor :type, :url, :explanation, :sector, :organisation_activity,
        :employing_eu_citizens, :personal_data, :intellectual_property,
        :funding_schemes, :public_sector_procurement, :pinned_content

      TYPE_OPTIONS = [
        "Adding content to the finder",
        "Update to tagging",
        "Removing content from the finder",
      ].freeze

      PINNED_CONTENT_OPTIONS = %w(Yes No).freeze

      SECTOR_OPTIONS = [
        "All sectors",
        "Accommodation",
        "Aerospace",
        "Agriculture and forestry (including wholesale)",
        "Air freight and air passenger services",
        "Arts, culture and heritage",
        "Automotive",
        "Auxiliary activities",
        "Charities",
        "Chemicals",
        "Clothing and consumer goods",
        "Clothing and consumer goods manufacture",
        "Construction",
        "Creative industries",
        "Defence",
        "Digital, technology and computer services",
        "Education",
        "Electricity",
        "Electronics, parts and machinery",
        "Environmental services",
        "Financial services",
        "Fisheries (including wholesale)",
        "Food, drink and tobacco (retail and wholesale)",
        "Food, drink and tobacco (processing)",
        "Furniture manufacture",
        "Gambling",
        "Health and social care services",
        "Installation, servicing and repair",
        "Insurance",
        "Justice including prisons",
        "Marine",
        "Marine transport",
        "Media and broadcasting",
        "Medical technology",
        "Metals manufacture",
        "Mining",
        "Motor trade",
        "Non-metal materials manufacture",
        "Nuclear",
        "Oil, gas and coal",
        "Other advanced manufacturing",
        "Other energy",
        "Other manufacturing",
        "Personal services",
        "Pharmaceuticals",
        "Ports and airports",
        "Postal and courier services",
        "Professional and business services",
        "Public administration",
        "Rail",
        "Rail (passengers and freight)",
        "Real estate",
        "Repair of computers and consumer goods",
        "Research",
        "Restaurants, bars and catering",
        "Retail and wholesale (excluding motor trade, food and drink)",
        "Road (passengers and freight)",
        "Space",
        "Sports and recreation",
        "Telecoms and information services",
        "Tourism",
        "Veterinary",
        "Voluntary and community organisations",
        "Warehouses, services and pipelines",
      ].freeze

      ORGANISATION_ACTIVITY_OPTIONS = [
        "Sell products or goods in the UK",
        "Buy products or goods from abroad",
        "Sell products or goods abroad",
        "Do other types of business in the EU",
        "Transport goods abroad",
      ].freeze

      EMPLOYING_EU_CITIZENS_OPTIONS = %w(Yes No).freeze

      PERSONAL_DATA_OPTIONS = %w(Yes No).freeze

      INTELLECTUAL_PROPERTY_OPTIONS = [
        "Copyright",
        "Trade marks",
        "Designs",
        "Patents",
        "Exhaustion of rights",
      ].freeze

      FUNDING_SCHEMES_OPTIONS = [
        "Receiving EU funding",
        "Receiving UK government funding",
      ].freeze

      PUBLIC_SECTOR_PROCUREMENT_OPTIONS = [
        "Civil government contracts",
        "Defence contracts",
      ].freeze

      validates_presence_of :url

      def self.label
        "Request updates to content in the EU Exit business readiness finder"
      end

      def self.description
        "Request to add content, update content tags or remove content from the EU Exit business readiness finder."
      end
    end
  end
end
