require 'support/requests/request'

module Support
  module Requests
    class UnpublishContentRequest < Request
      DEFAULTS = { automatic_redirect: "1" }

      attr_accessor :urls, :reason_for_unpublishing, :further_explanation, :redirect_url, :automatic_redirect
      validates_presence_of :urls, :reason_for_unpublishing

      validates_presence_of :redirect_url, :automatic_redirect, if: :another_page_involved?
      validates :automatic_redirect, inclusion: { in: ["1", "0", nil] }

      def initialize(attr = {})
        super(DEFAULTS.merge(attr))
      end

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

      def formatted_automatic_redirect
        (automatic_redirect == "1").to_s
      end

      def self.label
        "Unpublish content"
      end

      def self.description
        "Request to unpublish content"
      end

      def another_page_involved?
        ["duplicate_publication", "superseded_publication"].include? reason_for_unpublishing
      end
    end
  end
end
