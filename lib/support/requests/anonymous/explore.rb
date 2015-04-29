require 'uri'
require 'active_model/model'

module Support
  module Requests
    module Anonymous
      # this superclass is defined so authorisation can be defined on it
      class Explore
        include ActiveModel::Model
      end

      class ExploreByUrl < Explore
        attr_accessor :url
        validates_presence_of :url
        validate :url_is_well_formed

        def redirect_path
          Rails.application.routes.url_helpers.anonymous_feedback_index_path(path: path_from_url)
        end

        private
        def url_is_well_formed
          uri = URI.parse(url)
          valid = !uri.path.nil?
          errors.add(:url, "must be a valid URL") unless valid
        rescue URI::InvalidURIError
          errors.add(:url, "must be a valid URL")
        end

        def path_from_url
          path = URI(url).path
          path.sub(/^(www.)?gov.uk/, '')
        end
      end
    end
  end
end
