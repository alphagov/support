require 'support/requests/anonymous/anonymous_contact'

module Support
  module Requests
    module Anonymous
      class LongFormContact < AnonymousContact
        attr_accessible :url, :details

        validates_presence_of :details
        validates :url, length: { maximum: 2048 }
        validates :details, length: { maximum: 2 ** 16 }

        def govuk_link_path
          begin
            uri = URI.parse(url)
            uri.host == 'www.gov.uk' ? uri.path : nil
          rescue URI::InvalidURIError
            nil
          end
        end
      end
    end
  end
end
