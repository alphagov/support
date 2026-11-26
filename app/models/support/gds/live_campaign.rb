require "active_model/model"

module Support
  module GDS
    class LiveCampaign
      include ActiveModel::Model
      attr_accessor :title, :proposed_url, :description, :time_constraints, :reason_for_dates

      validates :title, :description, presence: true

      validates :proposed_url, format: { with: Campaign::VALID_URL_REGEX }
    end
  end
end
