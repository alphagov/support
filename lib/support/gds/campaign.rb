require 'active_model/model'

module Support
  module GDS
    class Campaign
      include ActiveModel::Model
      attr_accessor :title, :erg_reference_number, :start_date, :description, :affiliated_group_or_company, :info_url

      validates_presence_of :title, :description
      validates_date :start_date, :allow_nil => true, :allow_blank => true, :on_or_after => :today
    end
  end
end
