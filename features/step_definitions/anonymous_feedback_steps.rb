When /^the user submits the following problem report through the API:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  params = {
    "problem_report" => {
      "what_wrong" => @request_details['What went wrong'],
      "what_doing" => @request_details['What you were doing'],
      "url" => @request_details['URL'],
      "user_agent" => @request_details['User agent'],
      "javascript_enabled" => (@request_details['JS?'] == "yes"),
      "referrer" => @request_details['Referrer'],
      "source" => @request_details['Source'],
      "page_owner" => @request_details['Page owner'],
    }
  }

  post '/anonymous_feedback/problem_reports', params.to_json, {"CONTENT_TYPE" => 'application/json', 'HTTP_ACCEPT' => 'application/json'}

  assert_equal 201, last_response.status, "Request not successful, request: #{last_request.body.read}\nresponse: #{last_response.body}"
end

When /^the user submits the following long-form anonymous contact through the API:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  params = {
    "long_form_contact" => {
      "details" => @request_details['Details'],
      "link" => @request_details['Link'],
      "user_agent" => @request_details['User agent'],
      "javascript_enabled" => (@request_details['JS?'] == "yes"),
      "referrer" => @request_details['Referrer'],
      "url" => @request_details['URL'],
    }
  }

  post '/anonymous_feedback/long_form_contacts', params.to_json, {"CONTENT_TYPE" => 'application/json', 'HTTP_ACCEPT' => 'application/json'}

  assert_equal 201, last_response.status, "Request not successful, request: #{last_request.body.read}\nresponse: #{last_response.body}"
end

When /^the user submits feedback about a GOV[.]UK service through the API:$/ do |request_details_table|
  @request_details = request_details_table.hashes.first

  params = {
    "service_feedback" => {
      "slug" => @request_details['Slug'],
      "url" => @request_details['URL'],
      "improvement_comments" => @request_details['Improvement comments'],
      "service_satisfaction_rating" => @request_details['Satisfaction rating'].to_i,
      "user_agent" => @request_details['User agent'],
      "javascript_enabled" => (@request_details['JS?'] == "yes"),
    }
  }

  post '/anonymous_feedback/service_feedback', params.to_json, {"CONTENT_TYPE" => 'application/json', 'HTTP_ACCEPT' => 'application/json'}

  assert_equal 201, last_response.status, "Request not successful, request: #{last_request.body.read}\nresponse: #{last_response.body}"
end
