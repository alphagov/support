require "active_model/model"

module Support
  module GDS
    class Campaign
      include ActiveModel::Model
      include DesignSystemDateHelper
      attr_accessor :has_read_guidance_confirmation,
                    :has_read_oasis_guidance_confirmation,
                    :full_responsibility_confirmation,
                    :accessibility_confirmation,
                    :cookie_and_privacy_notice_confirmation,
                    :signed_campaign,
                    :start_day,
                    :start_month,
                    :start_year,
                    :end_day,
                    :end_month,
                    :end_year,
                    :development_start_day,
                    :development_start_month,
                    :development_start_year,
                    :performance_review_contact_email,
                    :government_theme,
                    :description,
                    :call_to_action,
                    :proposed_url,
                    :site_title,
                    :site_tagline,
                    :site_metadescription,
                    :cost_of_campaign,
                    :hmg_code,
                    :strategic_planning_code,
                    :ga_contact_email

      validates :signed_campaign,
                :start_day,
                :start_month,
                :start_year,
                :end_day,
                :end_month,
                :end_year,
                :development_start_day,
                :development_start_month,
                :development_start_year,
                :performance_review_contact_email,
                :government_theme,
                :description,
                :call_to_action,
                :proposed_url,
                :site_title,
                :site_tagline,
                :site_metadescription,
                :cost_of_campaign,
                :hmg_code,
                :strategic_planning_code,
                :ga_contact_email,
                presence: true

      validates :has_read_guidance_confirmation,
                :has_read_oasis_guidance_confirmation,
                :full_responsibility_confirmation,
                :accessibility_confirmation,
                :cookie_and_privacy_notice_confirmation,
                acceptance: { allow_nil: false, accept: "Yes" }
      validates_date :start_date, on_or_after: :today
      validates_date :end_date, after: :start_date
      validates_date :development_start_date, on_or_before: :start_date
      validates :proposed_url, format: /((http|https):\/\/)?[a-z0-9]+([-.]{1}[a-z0-9]+)*\.(campaign\.)?gov.uk?/

      VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      validates :performance_review_contact_email, :ga_contact_email, format: { with: VALID_EMAIL_REGEX }

      def start_date
        formatted_date(start_day, start_month, start_year)
      end

      def end_date
        formatted_date(end_day, end_month, end_year)
      end

      def development_start_date
        formatted_date(development_start_day, development_start_month, development_start_year)
      end
    end
  end
end
