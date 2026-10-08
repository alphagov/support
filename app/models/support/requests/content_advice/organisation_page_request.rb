# frozen_string_literal: true

module Support
  module Requests
    module ContentAdvice
      class OrganisationPageRequest < Request
        include WithTimeConstraint
        include ActiveModel::Validations::Callbacks

        LOGO_TYPES = ["Single identity system", "Plain text", "Custom logo"].freeze
        ORG_STATUSES = ["Coming soon", "Exempt from joining", "Currently transitioning"].freeze
        ORG_TYPES = [
          { type: "Ministerial department" },
          { type: "Non-ministerial department" },
          { type: "Executive agency" },
          { type: "Executive non-departmental public body" },
          { type: "Advisory non-departmental public body" },
          { type: "Court" },
          { type: "Tribunal" },
          { type: "Public corporation" },
          { type: "Independent monitoring body" },
          { type: "Ad-hoc advisory group" },
          { type: "Sub-organisation", hint: "These are typically large units within organisations" },
          { type: "Other", hint: "This includes regulators, independent organisations and companies owned by the government" },
        ].freeze

        attr_accessor :organisation_name,
                      :organisation_abbreviation,
                      :logo_type,
                      :sis_logo_format,
                      :plain_text_logo_format,
                      :gcs_exemption,
                      :parent_organisation,
                      :organisation_type,
                      :organisation_status,
                      :exempt_from_govuk,
                      :associated_organisations,
                      :alternative_format_email,
                      :govuk_lead_name,
                      :govuk_lead_email,
                      :additional_info,
                      :deadline

        validates :organisation_name, :logo_type, :parent_organisation, :organisation_type, :organisation_status, :govuk_lead_name, :govuk_lead_email, :alternative_format_email, :associated_organisations, :deadline, presence: true
        validates :logo_type, inclusion: { in: LOGO_TYPES }, if: -> { logo_type.present? }
        validates :organisation_status, inclusion: { in: ORG_STATUSES }, if: -> { organisation_status.present? }
        validates :organisation_type, inclusion: { in: ORG_TYPES.pluck(:type) }, if: -> { organisation_type.present? }
        validates :plain_text_logo_format, presence: true, if: :plain_text_logo?
        validates :sis_logo_format, presence: true, if: :sis_logo?
        validates :gcs_exemption, presence: true, if: :custom_logo?
        validates :alternative_format_email, format: { with: Support::Requests::Requester::VALID_EMAIL_REGEX }, if: -> { alternative_format_email.present? }
        validates :govuk_lead_email, format: { with: Support::Requests::Requester::VALID_EMAIL_REGEX }, if: -> { govuk_lead_email.present? }
        validates :exempt_from_govuk, presence: true, if: :exempt_from_joining?

        before_validation :set_time_constraint_requirement

        def initialize(attrs = {})
          self.time_constraint = TimeConstraint.new
          super
        end

        def title
          "#{organisation_name} - organisation page request"
        end

        def self.label
          "Request a new organisation page"
        end

        def self.description
          "Ask for a new GOV.UK page for your organisation or sub-organisation."
        end

        def details
          %i[
            organisation_name
            organisation_abbreviation
            logo_type
            logo_format
            gcs_exemption
            parent_organisation
            organisation_type
            organisation_status
            exempt_from_govuk
            associated_organisations
            alternative_format_email
            govuk_lead_name
            govuk_lead_email
            additional_info
          ].map { |field|
            value = public_send(field)

            next if value.blank?

            "[#{field.to_s.humanize}]\n" + value
          }.compact.join("\n\n")
        end

        def logo_format
          sis_logo_format.presence || plain_text_logo_format.presence
        end

        def set_time_constraint_requirement
          if time_constraint.present?
            time_constraint.is_required = (deadline == "Yes")
          end
        end

        def sis_logo?
          logo_type == "Single identity system"
        end

        def plain_text_logo?
          logo_type == "Plain text"
        end

        def custom_logo?
          logo_type == "Custom logo"
        end

        def exempt_from_joining?
          organisation_status == "Exempt from joining"
        end

        def org_type_options
          ORG_TYPES.map do |org_type|
            {
              value: org_type[:type],
              text: org_type[:type],
              hint_text: org_type[:hint],
              checked: organisation_type == org_type[:type],
            }
          end
        end
      end
    end
  end
end
