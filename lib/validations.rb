class Guard

  #Content validations
  def self.validationsForAddContent(form_data)
    required = ["name", "email", "job", "department", "target_url", "add_content", "need_by"]
    self.checkRequiredFieldsHaveValues(required, form_data)
    self.checkPhoneIsValid(form_data[:phone])
    self.checkEmailIsValid(form_data[:email])
  end

  def self.validationsForAmendContent(form_data)
    required = ["name", "email", "job", "department", "target_url", "old_content", "new_content", "need_by"]
    self.checkRequiredFieldsHaveValues(required, form_data)
    self.checkPhoneIsValid(form_data[:phone])
    self.checkEmailIsValid(form_data[:email])
  end

  def self.validationsForDeleteContent(form_data)
    required = ["name", "email", "job", "department", "target_url", "need_by"]
    self.checkRequiredFieldsHaveValues(required, form_data)
    self.checkPhoneIsValid(form_data[:phone])
    self.checkEmailIsValid(form_data[:email])
  end

  #User validations
  def self.validationsForUserAccess(form_data)
    required = ["name", "email", "job", "department", "user_name", "user_email"]
    self.checkRequiredFieldsHaveValues(required, form_data)
    self.checkPhoneIsValid(form_data[:phone])
    self.checkEmailIsValid(form_data[:email])
  end

  #Campaign validations
  def self.validationsForCampaign(form_data)
    required = ["name", "email", "job", "department", "campaign_name", "erg_number", "need_by", "description"]
    self.checkRequiredFieldsHaveValues(required, form_data)
    self.checkPhoneIsValid(form_data[:phone])
    self.checkEmailIsValid(form_data[:email])
  end

  #Tech issues
  def self.validationsForBrokenLink(form_data)
    required = ["name", "email", "job", "department", "target_url"]
    self.checkRequiredFieldsHaveValues(required, form_data)
    self.checkPhoneIsValid(form_data[:phone])
    self.checkEmailIsValid(form_data[:email])
  end

  def self.validationsForPublishTool(form_data)
    required = ["name", "email", "job", "department", "target_url", "username"]
    self.checkRequiredFieldsHaveValues(required, form_data)
    self.checkPhoneIsValid(form_data[:phone])
    self.checkEmailIsValid(form_data[:email])
  end


private

  def self.checkRequiredFieldsHaveValues(required, form_data)
    errors = []
    required.each {|field|
      if form_data[field] && form_data[field].empty?
        errors << "Please enter #{field}"
      end
    }

    errors
  end

  def self.checkPhoneIsValid(phone_fields)
    errors = []
    errors
  end

  def self.checkEmailIsValid(email_fields)
    errors = []
    errors
  end

end