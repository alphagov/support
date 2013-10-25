require 'support/requests/requester'

module Support
  module Requests
    module Anonymous
      class AnonymousContact < ActiveRecord::Base
        attr_accessible :referrer, :javascript_enabled, :user_agent
        validates :referrer, url: true, allow_nil: true

        def requester
          Requester.anonymous
        end

        validates :details, length: { maximum: 2 ** 16 }
        validates_inclusion_of :javascript_enabled, in: [ true, false ]
      end
    end
  end
end
