module Guard

  @required = {"/new" => ["name", "email", "job", "phone", "department", "target_url", "feedback", "need_by"]}
  @required_error_message = "Please enter #{field}\n"

  def checkRequiredFieldsHaveValues(from_url, form_data)
    errors = []
    @required[from_url].each {|field|
      if form_data[field].blank?
        errors << "Please enter #(field}"
      end
    }

    errors
  end
end
