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

        # correct user's URL entries to give them what they're after
        # we only really care about the path they've entered
        # strip out
        # - malformed http eg https:, http//:, http:/, http:///
        # - www.gov.uk and gov.uk
        # allow
        # treat some-path as if it were /some-path
        def path_from_url
          path = URI(url).path.sub(/^(http(s)?(:)?(\/)+?(:)?)?((\/)?www.)?gov.uk/, '')
          path.start_with?('/') ? path : "/#{path}"
        end

      private
        def url_is_well_formed
          uri = URI.parse(url)
          valid = !uri.path.nil?
          errors.add(:url, "must be a valid URL") unless valid
        rescue URI::InvalidURIError
          errors.add(:url, "must be a valid URL")
        end
      end
    end
  end
end
