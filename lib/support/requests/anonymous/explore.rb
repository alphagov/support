require 'uri'
require 'active_model/tableless_model'

module Support
  module Requests
    module Anonymous
      class Explore < ActiveModel::TablelessModel
        attr_accessor :by_url
        validates_presence_of :by_url
        validate :well_formed_url

        def path
          URI(by_url).path
        end

        private
        def well_formed_url
          uri = URI.parse(by_url)
          valid = (uri.kind_of?(URI::HTTP) or uri.kind_of?(URI::HTTPS)) && !uri.path.nil? && !uri.host.nil?
          errors.add(:by_url, "must be a valid URL") unless valid
        rescue URI::InvalidURIError
          errors.add(:by_url, "must be a valid URL") 
        end
      end
    end
  end
end
