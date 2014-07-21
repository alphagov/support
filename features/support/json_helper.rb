module JSONHelpers
  def post_json(url, payload)
    post url, payload.to_json, {
      "CONTENT_TYPE" => 'application/json',
      'HTTP_ACCEPT' => 'application/json',
      'HTTP_AUTHORIZATION' => 'Bearer 12345678'
    }
  end
end

World(JSONHelpers)
