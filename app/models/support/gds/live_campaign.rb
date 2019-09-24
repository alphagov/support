require "active_model/model"

module Support
  module GDS
    class LiveCampaign
      include ActiveModel::Model
      attr_accessor :title, :proposed_url, :description, :time_constraints, :reason_for_dates

      validates_presence_of :title, :description

      validates :proposed_url, format: /(http:\/\/|https:\/\/)?(www.)?([a-zA-Z0-9]+).[a-zA-Z0-9]*.[a-z]{3}.?([a-z]+)?/
    end
  end
end
