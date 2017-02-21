require 'active_model/model'

module Support
  module GDS
    class Campaign
      include ActiveModel::Model
      attr_accessor :title, :other_dept_or_agency, :signed_campaign, :start_date, :end_date, :description,
                    :call_to_action, :success_measure, :proposed_url, :site_metadescription, :cost_of_campaign

      validates_presence_of :title, :signed_campaign, :start_date, :end_date, :description,
                            :call_to_action, :success_measure, :proposed_url, :site_metadescription, :cost_of_campaign
      validates_date :start_date, on_or_after: :today, on_or_before: :end_date
      validates_date :end_date, on_or_after: :start_date
      validates :proposed_url, format: /((http|https):\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.campaign.gov.uk?/
    end
  end
end
