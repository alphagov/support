require 'uri'
require 'active_model/model'
require 'csv'

module Support
  module Requests
    module Anonymous
      # this superclass is defined so authorisation can be defined on it
      class Explore
        include ActiveModel::Model
      end

      class ExploreByMultiplePaths < Explore
        attr_accessor :uploaded_list, :list_of_urls
        validate :url_list_should_be_present
        validate :urls_are_well_formed

        def redirect_path
          Rails.application.routes.url_helpers.anonymous_feedback_index_path(paths: paths_from_urls)
        end

        # correct user's URL entries to give them what they're after
        # we only really care about the path they've entered
        # strip out
        # - malformed http eg https:, http//:, http:/, http:///
        # - www.gov.uk and gov.uk
        # allow
        # treat some-path as if it were /some-path
        def paths_from_urls
          urls = []
          parsed_urls.each do |url|
            path = URI(url).path.sub(/^(http(s)?(:)?(\/)+?(:)?)?((\/)?www.)?gov.uk/, '')
            urls << (path.start_with?('/') ? path : "/#{path}")
          end
          urls.uniq.join(', ')
        end

        def parsed_urls
          @parsed_urls ||= if uploaded_list.present?
                             CSV.parse(uploaded_list.read).flatten.map(&:strip)
                           elsif list_of_urls.present?
                             list_of_urls.split(',').map(&:strip)
                           else
                             []
                           end
        end

      private

        def url_list_should_be_present
          if uploaded_list.blank? && list_of_urls.blank?
            errors.add(:base, 'Please provide a valid list of urls.')
          end
        end

        def urls_are_well_formed
          parsed_urls.each do |path_or_url|
            begin
              uri = URI.parse(path_or_url)
              valid = !uri.path.nil?
              if list_of_urls.present?
                errors.add(:list_of_urls, "#{path_or_url} is not valid. Must contain only valid URLs") unless valid
              else
                errors.add(:uploaded_list, "#{path_or_url} is not valid. Must contain only valid URLs") unless valid
              end
            rescue URI::InvalidURIError
              errors.add(:base, "#{path_or_url} is not valid. Must contain only valid URLs")
            end
          end
        end
      end

      class ExploreByOrganisation < Explore
        attr_accessor :organisation
        validates_presence_of :organisation

        def redirect_path
          Rails.application.routes.url_helpers.anonymous_feedback_organisation_path(
            slug: organisation
          )
        end
      end
    end
  end
end
