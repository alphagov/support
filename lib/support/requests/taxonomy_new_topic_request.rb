require 'support/requests/request'
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
        "Add a topic"
      end

      def self.description
        "For requesting new topics in the education or parenting and childcare taxonomies."
      end
    end
  end
end
