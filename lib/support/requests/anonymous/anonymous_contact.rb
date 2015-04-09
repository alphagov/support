require 'support/requests/requester'
require 'support/requests/anonymous/with_personal_information_checking'
require 'support/requests/anonymous/anonymous_contact_validations'

module Support
  module Requests
    module Anonymous
      class AnonymousContact < ActiveRecord::Base
        include WithPersonalInformationChecking
        include AnonymousContactValidations

        before_save do |feedback|
          detect_personal_information_in(feedback.details, feedback.what_wrong, feedback.what_doing)
        end

        paginates_per 50

        def url
          path.present? ? Plek.new.website_root + path : nil
        end

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
      end
    end
  end
end
