require "active_support/core_ext"

module Support
  module Requests
    class TaxonomyNewTopicRequest < Request
      attr_accessor :title, :url, :details, :parent

      validates :title, :url, :details, :parent, presence: true

      def initialize(attrs = {})
        super
      end

      def self.label
        "Suggest a new topic"
      end

      def self.description
        "Suggest a new topic for the GOV.UK topic taxonomy."
      end
    end
  end
end
