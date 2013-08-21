require 'support/requests/request'

module Support
  module Requests
    class ProblemReport < Request
      DEFAULTS = {requester: Requester.new(email: ZENDESK_ANONYMOUS_TICKETS_REQUESTER_EMAIL, name: "Anonymous feedback")}

      attr_accessor :what_doing, :what_wrong, :url, :user_agent, :javascript_enabled, :referrer, :source, :page_owner

      validates_inclusion_of :javascript_enabled, in: [ true, false ]

      validates :url, :referrer, url: true, allow_nil: true


      def initialize(options = {})
        super(DEFAULTS.merge(options))
      end

      def referrer_url_on_gov_uk?
        referrer and URI.parse(referrer).host == "www.gov.uk"
      end
    end
  end
end
