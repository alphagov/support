module WithRequestContext
  attr_accessor :request_context

  def self.included(base)
    base.validates_presence_of :request_context
    base.validates :request_context, :inclusion => { 
      :in => %w(mainstream inside_government detailed_guidance other),
      :message => "%{value} is not valid option"
    }
  end

  def formatted_request_context
    Hash[request_context_options].key(request_context)
  end

  def inside_government_related?
    %w{inside_government detailed_guidance}.include?(request_context)
  end

  def request_context_options
    [
      ["Mainstream (business/citizen)", "mainstream"],
      ["Inside Government", "inside_government"],
      ["Detailed Guidance", "detailed_guidance"],
      ["Other/Not sure", "other"]
    ]
  end
end