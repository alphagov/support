require 'support/requests/request'
require 'active_support/core_ext'

module Support
  module Requests
    class TaxonomyChangeTopicRequest < Request
      attr_accessor :title, :type_of_change, :details, :reasons

      validates_presence_of :title, :type_of_change, :details, :reasons
      validates :type_of_change, inclusion: { in: %w(name_of_topic position_of_topic merge_split_topic remove_topic other) }

      def initialize(attrs = {})
        super
      end

      def formatted_type_of_change
        Hash[type_of_change_options].key(type_of_change)
      end

      def type_of_change_options
        [
          ["Name of topic", "name_of_topic"],
          ["Position of topic in the taxonomy (move it up a level, for example)", "position_of_topic"],
          ["Merge or split the topic", "merge_split_topic"],
          ["Remove the topic", "remove_topic"],
          ["Something else", "other"],
        ]
      end

      def self.label
        "Change or remove a topic"
      end

      def self.description
        "Request a change to an existing topic."
      end
    end
  end
end
