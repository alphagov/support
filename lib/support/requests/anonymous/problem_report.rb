require 'support/requests/with_requester'

module Support
  module Requests
    module Anonymous
      class ProblemReport < ActiveRecord::Base
        include WithRequester

        attr_accessible :what_doing, :what_wrong, :url, :user_agent, :javascript_enabled, :referrer, :source, :page_owner

        validates_inclusion_of :javascript_enabled, in: [ true, false ]

        validates :url, :referrer, url: true, allow_nil: true

        def requester
          Requester.anonymous
        end

        def referrer_url_on_gov_uk?
          referrer and URI.parse(referrer).host == "www.gov.uk"
        end
      end
    end
  end
end
