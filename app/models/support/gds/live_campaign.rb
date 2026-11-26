require "active_model/model"

module Support
  module GDS
    class LiveCampaign
      include ActiveModel::Model
      attr_accessor :title, :description, :time_constraints, :reason_for_dates
      attr_reader :proposed_url

      validates :title, :description, presence: true

      validates :proposed_url, format: { with: Campaign::VALID_URL_REGEX }

      def proposed_url=(new_proposed_url)
        @proposed_url = new_proposed_url&.strip
      end
    end
  end
end
