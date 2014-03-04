require 'support/requests/requester'
require 'support/requests/anonymous/field_which_may_contain_personal_information'
require 'support/requests/anonymous/duplicate_detector'

module Support
  module Requests
    module Anonymous
      class AnonymousContact < ActiveRecord::Base
        attr_accessible :referrer, :javascript_enabled, :user_agent, :personal_information_status
        attr_accessible :is_actionable, :reason_why_not_actionable

        before_save :detect_personal_information

        def requester
          Requester.anonymous
        end

        validates :referrer, url: true, allow_nil: true
        validates :details, length: { maximum: 2 ** 16 }
        validates_inclusion_of :javascript_enabled, in: [ true, false ]
        validates_inclusion_of :personal_information_status, in: [ "suspected", "absent" ], allow_nil: true
        validates_inclusion_of :is_actionable, in: [ true, false ]
        validates_presence_of :reason_why_not_actionable, unless: "is_actionable"

        scope :free_of_personal_info, where(personal_information_status: "absent")
        scope :only_actionable, where(is_actionable: true)

        def path
          URI(url).path
        rescue ArgumentError
          nil
        rescue URI::InvalidURIError
          nil
        end

        def self.find_all_starting_with_path(path)
          where("url is not null and url like ?", "%" + path + "%").
            free_of_personal_info.
            only_actionable.
            order("created_at desc").
            select { |pr| pr.path && pr.path.start_with?(path) }
        end

        def self.deduplicate_contacts_created_between(interval)
          contacts = where(created_at: interval).order("created_at asc")
          duplicate_detector = DuplicateDetector.new
          contacts.each do |contact|
            if duplicate_detector.duplicate?(contact)
              contact.mark_as_duplicate
              contact.save!
            end
          end
        end

        def mark_as_duplicate
          self.is_actionable = false
          self.reason_why_not_actionable = "duplicate"
          self
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
