require 'support/requests/anonymous/field_which_may_contain_personal_information'

module Support
  module Requests
    module Anonymous
      module WithPersonalInformationChecking
        def self.included(base)
          base.validates_inclusion_of :personal_information_status, in: [ "suspected", "absent" ], allow_nil: true
          base.scope :free_of_personal_info, -> { base.where(personal_information_status: "absent") }
        end

        def detect_personal_information_in(*fields)
          any_personal_info = fields.any? { |field| personal_info_present_in?(field) }
          self.personal_information_status ||= any_personal_info ? "suspected" : "absent"
        end

        private
        def personal_info_present_in?(text)
          FieldWhichMayContainPersonalInformation.new(text).include_personal_info?
        end
      end
    end
  end
end
