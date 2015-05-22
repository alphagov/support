require 'uri'

module ReferrerHelper

  def friendly_referrer(referrer)
    uri = URI.parse(referrer)
    if uri.host
      if (uri.host.match(/www\.gov.uk/))
        uri.path
      else
        uri.host.sub(/www\./,'')
      end
    else
      referrer
    end
  rescue URI::InvalidURIError
    referrer
  end

  def extract_search_term(referrer)
    uri = URI.parse(referrer)
    params = Rack::Utils.parse_query(uri.query)
    params['q'] if params['q'].present?
  rescue URI::InvalidURIError, ArgumentError
    nil
  end
end
