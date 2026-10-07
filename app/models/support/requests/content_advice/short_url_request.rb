# frozen_string_literal: true

module Support
  module Requests
    module ContentAdvice
      class ShortUrlRequest < Request
        include WithTimeConstraint
        include ActiveModel::Validations::Callbacks

        attr_accessor :title,
                      :destination_page,
                      :reason,
                      :usage,
                      :marketing_message,
                      :organisations_using_url,
                      :additional_info,
                      :deadline

        validates :title, :destination_page, :reason, :usage, :marketing_message, :organisations_using_url, :deadline, presence: true

        before_validation :set_time_constraint_requirement

        def initialize(attrs = {})
          self.time_constraint = TimeConstraint.new
          super
        end

        def self.label
          "Request a short URL"
        end

        def self.description
          "Ask for a new GOV.UK short URL to make long URLs easier for users to remember and type in."
        end

        def details
          %i[destination_page reason usage marketing_message organisations_using_url additional_info].map { |field|
            value = public_send(field)

            next if value.blank?

            "[#{field.to_s.humanize}]\n" + value
          }.join("\n\n")
        end

        def set_time_constraint_requirement
          if time_constraint.present?
            time_constraint.is_required = (deadline == "Yes")
          end
        end
      end
    end
  end
end
