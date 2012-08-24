class Guard

  #Content validations
  def self.validationsForAddContent(form_data)
    @@errors = []
    #required = ["name", "email", "job", "department", "target_url", "add_content", "need_by"]
    required = ["name", "email", "job", "department", "target_url", "add_content"]
    validate(form_data, required, {:phone => form_data[:phone]}, {:email => form_data[:email]})

    @@errors
  end


  def self.validationsForAmendContent(form_data)
    @@errors = []
    #required = ["name", "email", "job", "department", "target_url", "old_content", "new_content", "need_by"]
    required = ["name", "email", "job", "department", "target_url", "old_content", "new_content"]
    validate(form_data, required, {:phone => form_data[:phone]}, {:email => form_data[:email]})

    @@errors
  end

  def self.validationsForDeleteContent(form_data)
    @@errors = []
    #required = ["name", "email", "job", "department", "target_url", "need_by"]
    required = ["name", "email", "job", "department", "target_url"]
    validate(form_data, required, {:phone => form_data[:phone]}, {:email => form_data[:email]})

    @@errors
  end



  #User validations
  def self.validationsForUserAccess(form_data)
    @@errors = []
    required = ["name", "email", "job", "department", "user_name", "user_email"]
    validate(form_data, required, {:phone => form_data[:phone]}, {:email => form_data[:email]})

    @@errors
  end



  #Campaign validations
  def self.validationsForCampaign(form_data)
    @@errors = []
    #required = ["name", "email", "job", "department", "campaign_name", "erg_number", "need_by", "description"]
    required = ["name", "email", "job", "department", "campaign_name", "erg_number", "description"]
    validate(form_data, required, {:phone => form_data[:phone]}, {:email => form_data[:email]})

    @@errors
  end



  #Tech issues
  def self.validationsForBrokenLink(form_data)
    @@errors = []
    required = ["name", "email", "job", "department", "target_url"]
    validate(form_data, required, {:phone => form_data[:phone]}, {:email => form_data[:email]})

    @@errors
  end

  def self.validationsForPublishTool(form_data)
    @@errors = []
    required = ["name", "email", "job", "department", "target_url", "username"]
    validate(form_data, required, {:phone => form_data[:phone]}, {:email => form_data[:email]})

    @@errors
  end


private

  def self.validate(form_data, required, phone_fields, email_fields)
    self.checkRequiredFieldsHaveValues(required, form_data)
    self.checkPhoneIsValid(phone_fields)
    self.checkEmailIsValid(email_fields)
  end


  def self.checkRequiredFieldsHaveValues(required, form_data)
    required.each { |field|
      if form_data[field] && form_data[field].empty?
        field = field.capitalize
        @@errors << "#{field} is required for a valid ticket. Please enter some value."
      end
    }
  end

  def self.checkPhoneIsValid(phone_fields)
    phone_fields.each do |field_name, field_value|
      if !(field_value =~ /^[\d|\s]+[\d|\s]*$/)
        field_name = field_name.capitalize
        @@errors << "#{field_name} is a phone number field. Please enter only numbers and spaces."
      end
    end
  end

  def self.checkEmailIsValid(email_fields)
    email_fields.each  do |field_name, field_value|
      if !(field_value =~ /[\w\d]+.*@[\w\d]+.*/)
        field_name = field_name.capitalize
        @@errors << "#{field_name} is a email field. Please enter valid email like x@y.something."
      end
    end
  end

end