require 'support/requests/anonymous/anonymous_contact'

module Support
  module Requests
    module Anonymous
      class LongFormContact < AnonymousContact
        attr_accessible :url, :details, :user_specified_url

        validates_presence_of :details
        validates :url, length: { maximum: 2048 }
        validates :user_specified_url, length: { maximum: 2048 }
        validates :details, length: { maximum: 2 ** 16 }

        def govuk_link_path
          uri = URI.parse(user_specified_url)
          uri.host == 'www.gov.uk' ? uri.path : nil
        rescue URI::InvalidURIError
          nil
        end
      end
    end
  end
end
