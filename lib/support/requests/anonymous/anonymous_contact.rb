require 'support/requests/requester'
require 'support/requests/anonymous/field_which_may_contain_personal_information'

module Support
  module Requests
    module Anonymous
      class AnonymousContact < ActiveRecord::Base
        attr_accessible :referrer, :javascript_enabled, :user_agent, :personal_information_status
        validates :referrer, url: true, allow_nil: true

        before_save :detect_personal_information

        def requester
          Requester.anonymous
        end

        validates :details, length: { maximum: 2 ** 16 }
        validates_inclusion_of :javascript_enabled, in: [ true, false ]
        validates_inclusion_of :personal_information_status, in: [ "suspected", "absent" ], allow_nil: true

        def self.free_of_personal_info
          where(personal_information_status: "absent")
        end

        def path
          URI(url).path
        rescue ArgumentError
          nil
        rescue URI::InvalidURIError
          nil
        end

        def self.find_all_starting_with_path(path)
          where("url is not null and url like ?", "%" + path + "%").free_of_personal_info.order("created_at desc").select { |pr| pr.path && pr.path.start_with?(path) }
        end

        private
        def detect_personal_information
          self.personal_information_status ||= personal_info_present? ? "suspected" : "absent"
        end

        def personal_info_present?
          free_text_fields = [ self.details, self.what_wrong, self.what_doing ]
          free_text_fields.any? { |text| FieldWhichMayContainPersonalInformation.new(text).include_personal_info? }
        end
      end
    end
  end
end
