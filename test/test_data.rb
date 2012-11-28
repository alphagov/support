module TestData
  def valid_content_change_request_params
    {"content_change_request" => 
      { "requester_attributes"       => valid_requester_params,
        "time_constraint_attributes" => valid_time_constraint_params,
        "url1"                       => "https://www.gov.uk",
        "details_of_change"          => "Content is wrong",
        "request_context"            => "mainstream" }
    }
  end

  def valid_create_new_user_request_params
    { "create_new_user_request" =>
      { "requester_attributes" => valid_requester_params,
        "user_name"=>"subject",
        "user_email"=>"subject@digital.cabinet-office.gov.uk",
        "tool_role" => "govt_form",
        "additional_comments"=>"" }
    }
  end

  def valid_remove_user_request_params
    { "remove_user_request" =>
      { "requester_attributes" => valid_requester_params,
        "time_constraint_attributes" => {"not_before_date" => "01-12-2022"},
        "user_name"=>"subject",
        "user_email"=>"subject@digital.cabinet-office.gov.uk",
        "tool_role" => "govt_form",
        "additional_comments"=>"" }
    }
  end

  def valid_general_request_params
    {"general_request" => 
      { "requester_attributes" => valid_requester_params,
        "url"=>"testing",
        "additional"=>"" }
    }
  end

  def valid_requester_params
    { "name"=>"Testing",
      "email"=>"testing@digital.cabinet-office.gov.uk",
      "job"=>"dev",
      "phone"=>"",
    }
  end

  def valid_time_constraint_params
    { "needed_by_date" => "01-01-2023",
      "not_before_date" => "01-12-2022",
      "time_constraint_reason" => "Legal requirement"
    }
  end
end
