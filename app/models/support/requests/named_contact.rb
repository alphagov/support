require 'uri'

module Support
  module Requests
    class NamedContact < Request
      attr_accessor :link, :details, :referrer, :javascript_enabled, :user_agent

      validates_presence_of :details
      validates_inclusion_of :javascript_enabled, in: [true, false]

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
