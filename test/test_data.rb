module TestData
  def valid_content_change_request_params
    { "name"=>"Testing",
      "email"=>"testing@digital.cabinet-office.gov.uk",
      "job"=>"Dev",
      "phone"=>"",
      "organisation"=>"cabinet_office",
      "other_organisation"=>"",
      "inside_government" => "no",
      "url1"=>"",
      "url2"=>"",
      "url3"=>"",
      "add_content"=>"",
      "need_by_day"=>"",
      "need_by_month"=>"",
      "need_by_year"=>"",
      "not_before_day"=>"",
      "not_before_month"=>"",
      "not_before_year"=>"",
      "additional"=>"" }
  end

  def valid_create_new_user_request_params
    { "name"=>"Testing",
      "email"=>"testing@digital.cabinet-office.gov.uk",
      "job"=>"dev",
      "phone"=>"",
      "organisation"=>"cabinet_office",
      "other_organisation"=>"",
      "user_name"=>"subject",
      "user_email"=>"subject@digital.cabinet-office.gov.uk",
      "additional"=>"" }
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
      { "name"=>"Testing",
        "email"=>"testing@digital.cabinet-office.gov.uk",
        "job"=>"dev",
        "phone"=>"",
        "organisation"=>"cabinet_office",
        "other_organisation"=>"",
        "url"=>"testing",
        "additional"=>"" }
    }
  end
end
