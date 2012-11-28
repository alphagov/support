require 'tableless_model'
require 'with_requester'

class CampaignRequest < TablelessModel
  include WithRequester

  attr_accessor :campaign
  validates_presence_of :campaign
  validate do |request|
    if request.campaign and not request.campaign.valid?
      errors[:base] << "Campaign details are either not complete or invalid."
    end
  end

  def campaign_attributes=(attr)
    self.campaign = Campaign.new(attr)
  end

  attr_accessor :additional_comments
end