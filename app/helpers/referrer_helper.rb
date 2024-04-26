require "uri"

module ReferrerHelper
  def friendly_referrer(referrer)
    uri = URI.parse(referrer)
    if uri.host
      if /\Awww\.gov.uk/.match?(uri.host)
        uri.path
      else
        uri.host.sub(/www\./, "")
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
    params["q"].presence
  rescue URI::InvalidURIError, ArgumentError
    nil
  end
end
