When /^the user submits the following FOI request through the API:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  params = { "foi_request" => {} }

  params["foi_request"]["requester"] = { "name" => @request_details['Name'], "email" => @request_details['Email'] }
  params["foi_request"]["details"] = @request_details['Details']

  post '/foi_requests', params.to_json, {"CONTENT_TYPE" => 'application/json', 'HTTP_ACCEPT' => 'application/json', 'HTTP_AUTHORIZATION' => 'Bearer 12345678'}

  assert_equal 201, last_response.status, "Request not successful, response: #{last_response.body}"
end
