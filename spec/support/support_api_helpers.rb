module SupportApiHelpers
  def stub_anonymous_feedback_with_default_date_range(params, response_body={})
    params = default_date_range.merge(params)
    stub_anonymous_feedback(params, response_body)
  end

  def default_date_range
    {
      from: 30.days.ago.strftime("%e %b %Y"),
      to: Date.today.strftime("%e %b %Y")
    }
  end
end

RSpec.configure do |config|
  config.include SupportApiHelpers
end
