require 'uri'
require 'active_model/tableless_model'

module Support
  module Requests
    module Anonymous
      # this superclass is defined so authorisation can be defined on it
      class Explore < ActiveModel::TablelessModel; end

      class ExploreByUrl < Explore
        attr_accessor :url
        validates_presence_of :url
        validate :url_is_well_formed

        def path
          URI(url).path
        end

        private
        def url_is_well_formed
          uri = URI.parse(url)
          valid = (uri.kind_of?(URI::HTTP) or uri.kind_of?(URI::HTTPS)) && !uri.path.nil? && !uri.host.nil?
          errors.add(:url, "must be a valid URL") unless valid
        rescue URI::InvalidURIError
          errors.add(:url, "must be a valid URL")
        end
      end
    end
  end
end
