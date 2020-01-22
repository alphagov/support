require "active_model/model"

module Support
  module GDS
    class Campaign
      include ActiveModel::Model
      attr_accessor :type_of_site, :has_read_guidance_confirmation, :has_read_oasis_guidance_confirmation,
                    :signed_campaign, :start_date, :end_date, :development_start_date,
                    :performance_review_contact_email, :government_theme, :description, :call_to_action,
                    :proposed_url, :site_title, :site_tagline, :site_metadescription, :cost_of_campaign,
                    :ga_contact_email

      validates :type_of_site, :signed_campaign, :start_date, :end_date, :development_start_date,
                :performance_review_contact_email, :government_theme, :description, :call_to_action,
                :proposed_url, :site_title, :site_tagline, :site_metadescription, :cost_of_campaign,
                :ga_contact_email, presence: true

      validates :has_read_guidance_confirmation, :has_read_oasis_guidance_confirmation, acceptance: { allow_nil: false }
      validates :type_of_site, inclusion: { in: ["Campaign platform", "Bespoke microsite"] }

      validates_date :start_date, on_or_after: :today, before: :end_date
      validates_date :end_date, after: :start_date
      validates_date :development_start_date, on_or_before: :start_date
      validates :proposed_url, format: /((http|https):\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.(campaign\.)?gov.uk?/

      VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
      validates :performance_review_contact_email, :ga_contact_email, format: { with: VALID_EMAIL_REGEX }
    end
  end
end
