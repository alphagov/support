require "active_support/core_ext"

module Support
  module Requests
    class TaxonomyChangeTopicRequest < Request
      attr_accessor :title, :type_of_change, :details, :reasons

      validates :title, :type_of_change, :details, :reasons, presence: true
      validates :type_of_change, inclusion: { in: %w[name_of_topic position_of_topic merge_split_topic remove_topic other] }

      def initialize(attrs = {})
        super
      end

      def formatted_type_of_change
        Hash[type_of_change_options].key(type_of_change)
      end

      def type_of_change_options
        [
          ["Name of topic", "name_of_topic"],
          ["Position in the topic taxonomy (move it up a level, for example)", "position_of_topic"],
          ["Merge or split the topic", "merge_split_topic"],
          ["Remove the topic", "remove_topic"],
          ["Something else", "other"],
        ]
      end

      def self.label
        "Suggest a change to a topic"
      end

      def self.description
        "Suggest a change to a topic or the removal of a topic in the GOV.UK topic taxonomy."
      end
    end
  end
end
