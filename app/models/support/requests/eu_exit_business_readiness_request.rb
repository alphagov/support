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
        "Digital, technology and computer services",
        "Creative industries",
        "Defence",
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
        "Professional business services",
        "Public administration",
        "Rail",
        "Road (passengers and freight)",
        "Rail (passengers and freight)",
        "Real estate",
        "Repair of computers and consumer goods",
        "Research",
        "Restaurants, bars and catering",
        "Retail and wholesale (excluding motor trade, food and drink)",
        "Space",
        "Sports and recreation",
        "Telecoms and information services",
        "Tourism",
        "Veterinary",
        "Voluntary and community organisations",
        "Warehouses, services and pipelines",
      ].freeze

      BUSINESS_ACTIVITY_OPTIONS = [
        "Selling products or goods in the UK",
        "Buying products or goods from abroad",
        "Selling products or goods abroad",
        "Doing other types of business in the EU",
        "Businesses transporting goods abroad",
      ].freeze

      EMPLOYING_EU_CITIZENS_OPTIONS = %w(Yes No).freeze

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
