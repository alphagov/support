require 'active_support/core_ext'

module Support
  module Requests
    class TaxonomyNewTopicRequest < Request
      attr_accessor :title, :url, :details, :parent

      validates_presence_of :title, :url, :details, :parent

      def initialize(attrs = {})
        super
      end

      def self.label
        "Suggest a new topic"
      end

      def self.description
        "Suggest a new topic for the GOV.UK taxonomy."
      end
    end
  end
end
