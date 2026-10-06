# frozen_string_literal: true

module Support
  module Requests
    module ContentAdvice
      class GroupPageRequest < Request
        include WithTimeConstraint

        attr_accessor :group_name,
                      :purpose,
                      :user_needs_evidence,
                      :contact_reason,
                      :additional_info,
                      :deadline,
                      :time_constraint

        validates :group_name, :purpose, :user_needs_evidence, :contact_reason, :deadline, presence: true

        def initialize(attrs = {})
          self.time_constraint = TimeConstraint.new
          super
        end

        def self.label
          "Request a new group page"
        end

        def self.description
          "Ask for permission to create a new GOV.UK page for a group in your organisation."
        end

        def title
          "#{group_name} - group page request"
        end

        def details
          %i[group_name purpose user_needs_evidence contact_reason additional_info].map { |field|
            value = public_send(field)

            next if value.blank?

            "[#{field.to_s.humanize}]\n" + value
          }.join("\n\n")
        end
      end
    end
  end
end
