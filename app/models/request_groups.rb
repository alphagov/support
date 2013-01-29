class RequestGroups
  include Enumerable

  def initialize
    @groups = [
      RequestGroup.new("Content request", [ContentChangeRequest, NewFeatureRequest]),
      RequestGroup.new("User Access", [CreateNewUserRequest, RemoveUserRequest]),
      RequestGroup.new("Campaigns", [CampaignRequest]),
      RequestGroup.new("Other Issues", [AnalyticsRequest, GeneralRequest]),
    ]
  end

  def each(&block)
    @groups.each(&block)
  end

  def all_request_classes
    @groups.collect(&:request_classes).flatten
  end
end