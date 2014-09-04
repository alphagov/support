require 'support/requests/requester'
require 'support/requests/anonymous/with_personal_information_checking'
require 'support/requests/anonymous/anonymous_contact_validations'

module Support
  module Requests
    module Anonymous
      class AnonymousContact < ActiveRecord::Base
        include WithPersonalInformationChecking
        include AnonymousContactValidations

        attr_accessible :url, :path, :referrer, :javascript_enabled, :user_agent, :personal_information_status
        attr_accessible :is_actionable, :reason_why_not_actionable

        before_save :set_path_from_url
        before_save do |feedback|
          detect_personal_information_in(feedback.details, feedback.what_wrong, feedback.what_doing)
        end

        paginates_per 50

        def requester
          Requester.anonymous
        end

        scope :only_actionable, -> { where(is_actionable: true) }
        scope :find_all_starting_with_path, ->(path) {
          where("path is not null and path like ?", path + "%").
            free_of_personal_info.
            only_actionable.
            order("created_at desc")
        }

        private
        def set_path_from_url
          self.path = URI.parse(url).path unless url.nil?
        end
      end
    end
  end
end
