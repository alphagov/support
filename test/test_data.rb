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
        "inside_government" => "no",
        "additional_comments"=>"" }
    }
  end

  def valid_remove_user_request_params
    { "name"=>"Testing",
      "email"=>"testing@digital.cabinet-office.gov.uk",
      "job"=>"This is just a test",
      "phone"=>"",
      "organisation"=>"cabinet_office",
      "other_organisation"=>"",
      "user_name"=>"testing",
      "user_email"=>"ignore-me@foo.com",
      "not_before_day"=>"",
      "not_before_month"=>"",
      "not_before_year"=>"",
      "additional"=>"" }
  end

  def valid_campaign_request_params
    { "name"=>"Testing",
      "email"=>"testing@digital.cabinet-office.gov.uk",
      "job"=>"doo",
      "phone"=>"",
      "organisation"=>"cabinet_office",
      "other_organisation"=>"",
      "campaign_name"=>"Testing",
      "erg_number"=>"1234",
      "start_day"=>"",
      "start_month"=>"",
      "start_year"=>"",
      "description"=>"Testing",
      "company"=>"",
      "url"=>"",
      "additional"=>"" }
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
      "organisation"=>"cabinet_office",
      "other_organisation"=>"",
    }
  end

  def valid_time_constraint_params
    { "needed_by_date" => "01-01-2013",
      "not_before_date" => "01-12-2012",
      "time_constraint_reason" => "Legal requirement"
    }
  end
end
