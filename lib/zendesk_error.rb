class ZendeskError < StandardError

  attr_reader :message, :details_from_zendesk

  def initialize(message, details_from_zendesk)
    @message = message.to_s
    @details_from_zendesk = details_from_zendesk
  end

end