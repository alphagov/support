When /^the user submits the following named contact through the API:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  params = { "named_contact" => {} }

  params["named_contact"]["requester"] = { "name" => @request_details['Name'], "email" => @request_details['Email'] }
  params["named_contact"].merge!(
    "details" => @request_details['Details'],
    "link" => @request_details['Link'],
    "user_agent" => @request_details['User agent'],
    "javascript_enabled" => (@request_details['JS?'] == "yes"),
    "referrer" => @request_details['Referrer'],
  )

  post_json '/named_contacts', params

  assert_equal 201, last_response.status, "Request not successful, response: #{last_response.body}"
end
