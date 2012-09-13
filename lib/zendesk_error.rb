class ZendeskError < StandardError

  attr_reader :message

  def initialize(message)
    @message = message.to_s
  end

end