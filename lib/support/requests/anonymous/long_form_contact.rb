require 'support/requests/request'

module Support
  module Requests
    module Anonymous
      class LongFormContact < ActiveRecord::Base
        attr_accessible :link, :details, :referrer, :javascript_enabled, :user_agent

        def requester
          Requester.anonymous
        end

        validates_presence_of :details
        validates :link, length: { maximum: 2048 }
        validates :details, length: { maximum: 2 ** 16 }
        validates_inclusion_of :javascript_enabled, in: [ true, false ]

        def govuk_link_path
          begin
            uri = URI.parse(link)
            uri.host == 'www.gov.uk' ? uri.path : nil
          rescue URI::InvalidURIError
            nil
          end
        end
      end
    end
  end
end
