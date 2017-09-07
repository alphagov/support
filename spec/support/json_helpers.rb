require 'gds_zendesk/test_helpers'

module JsonHelpers
  def json_response
    JSON.parse(response.body)
  end

  def get_json(url)
    get(
      url,
      "",
      'CONTENT_TYPE' => 'application/json',
      'HTTP_ACCEPT' => 'application/json',
      'HTTP_AUTHORIZATION' => 'Bearer 12345678'
    )
  end

  def post_json(url, payload)
    post(
      url,
      payload.to_json,
      'CONTENT_TYPE' => 'application/json',
      'HTTP_ACCEPT' => 'application/json',
      'HTTP_AUTHORIZATION' => 'Bearer 12345678'
    )
  end
end

RSpec.configure { |c| c.include JsonHelpers }
