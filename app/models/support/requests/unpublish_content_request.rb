module Support
  module Requests
    class UnpublishContentRequest < Request
      DEFAULTS = { automatic_redirect: "1" }.freeze

      attr_accessor :urls, :reason_for_unpublishing, :further_explanation, :redirect_url, :automatic_redirect
      validates :urls, :reason_for_unpublishing, presence: true

      validates :redirect_url, :automatic_redirect, presence: { if: :another_page_involved? }
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
        %w(duplicate_publication superseded_publication).include? reason_for_unpublishing
      end
    end
  end
end
