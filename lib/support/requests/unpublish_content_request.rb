require 'support/requests/request'

module Support
  module Requests
    class UnpublishContentRequest < Request

      attr_accessor :urls, :reason_for_unpublishing, :further_explanation
      validates_presence_of :urls, :reason_for_unpublishing

      def reason_for_unpublishing_options
        [
          ["Published in error", "published_in_error"],
          ["Duplicate of another page", "duplicate_publication"],
          ["Superseded by another page", "superseded_publication"],
        ]
      end

      def formatted_reason_for_unpublishing
        Hash[reason_for_unpublishing_options].key(reason_for_unpublishing)
      end

      def self.label
        "Unpublish content"
      end
    end
  end
end
