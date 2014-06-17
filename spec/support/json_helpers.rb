require 'gds_zendesk/test_helpers'

module JsonHelpers
  def json_response
    JSON.parse(response.body)
  end
end

RSpec.configure { |c| c.include JsonHelpers }
