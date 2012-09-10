require "date"

class Guard

  MAX_UPLOAD_FILE_SIZE_IN_BYTE = 20971520 #20MB

  #Content validations
  def self.validationsForNewNeed(form_data)
    @@errors = {}
    required = ["name", "email", "job", "department"]
    validate(form_data, required, {:phone => form_data["phone"]}, {:email => form_data["email"]})

    @@errors
  end

  def self.validationsForAmendContent(form_data)
    @@errors = {}
    required = ["name", "email", "job", "department"]
    validate(form_data, required, {:phone => form_data["phone"]}, {:email => form_data["email"]})
    self.checkOptionalDateFieldsAreComplete(form_data, [["Need by", "need_by_day", "need_by_month", "need_by_year"], ["Not before", "not_before_day", "not_before_month", "not_before_year"]])

    need_by = validate_date_in_valid_range("Need by", "need_by_day", "need_by_month", "need_by_year", form_data)
    not_before = validate_date_in_valid_range("Not before", "not_before_day", "not_before_month", "not_before_year", form_data)

    self.validate_date_is_equal_or_greater_than_today("Need by", need_by, "Changes can only be made after today.")
    self.validate_not_before_date_is_equal_or_greater_than_need_by(not_before, need_by, "Not before date should be the same or later than the date which the changes are required to be made on.")

    if form_data[:uploaded_data] && self.doesFieldHaveValue(form_data[:uploaded_data][:filename])
      validate_upload_file("uploaded_data", form_data[:uploaded_data])
    end
    @@errors
  end

  #User validations
  def self.validationsForCreateUser(form_data)
    @@errors = {}
    if form_data[:uploaded_data] && self.doesFieldHaveValue(form_data[:uploaded_data][:filename])
      required = ["name", "email", "job", "department"]
    else
      required = ["name", "email", "job", "department", "user_name", "user_email"]
    end
    validate(form_data, required, {:phone => form_data["phone"]}, {:email => form_data["email"]})

    if form_data[:uploaded_data] && self.doesFieldHaveValue(form_data[:uploaded_data][:filename])
      validate_upload_file("uploaded_data", form_data[:uploaded_data])
    end

    @@errors
  end

  def self.validationsForResetPassword(form_data)
    @@errors = {}
    required = ["name", "email", "job", "department", "user_name", "user_email"]
    validate(form_data, required, {:phone => form_data["phone"]}, {:email => form_data["email"]})

    @@errors
  end

  def self.validationsForDeleteUser(form_data)
    @@errors = {}

    if form_data[:uploaded_data] && self.doesFieldHaveValue(form_data[:uploaded_data][:filename])
      required = ["name", "email", "job", "department"]
    else
      required = ["name", "email", "job", "department", "user_name", "user_email"]
    end

    validate(form_data, required, {:phone => form_data["phone"]}, {:email => form_data["email"]})
    self.checkOptionalDateFieldsAreComplete(form_data, [["Not before", "not_before_day", "not_before_month", "not_before_year"]])

    not_before = validate_date_in_valid_range("Not_before", "not_before_day", "not_before_month", "not_before_year", form_data)
    self.validate_date_is_equal_or_greater_than_today("Not before", not_before, "Not before date should be the same or later than today.")

    if form_data[:uploaded_data] && self.doesFieldHaveValue(form_data[:uploaded_data][:filename])
      validate_upload_file("uploaded_data", form_data[:uploaded_data])
    end

    @@errors
  end


  #Campaign validations
  def self.validationsForCampaign(form_data)
    @@errors = {}
    required = ["name", "email", "job", "department", "campaign_name", "erg_number", "description"]
    validate(form_data, required, {:phone => form_data["phone"]}, {:email => form_data["email"]})

    self.checkOptionalDateFieldsAreComplete(form_data, [["Start date", "start_day", "start_month", "start_year"]])

    start_date = validate_date_in_valid_range("Start date", "start_day", "start_month", "start_year", form_data)
    self.validate_date_is_equal_or_greater_than_today("Start date", start_date, "Campaign start date can only be after today.")

    @@errors
  end

  #Tech issues
  def self.validationsForBrokenLink(form_data)
    @@errors = {}
    required = ["name", "email", "job", "department", "url"]
    validate(form_data, required, {:phone => form_data["phone"]}, {:email => form_data["email"]})

    @@errors
  end

  def self.validationsForPublishTool(form_data)
    @@errors = {}
    required = ["name", "email", "job", "department", "url", "username"]
    validate(form_data, required, {:phone => form_data["phone"]}, {:email => form_data["email"]})

    @@errors
  end

  #Zendesk validation fail
  def self.fail_to_create_ticket()
    @@errors["zendesk"] = "Has failed to submit request. Please ensure all the information has been entered correctly and try to submit it later."
  end


  private

  def self.validate(form_data, required, phone_fields, email_fields)
    self.checkRequiredFieldsHaveValues(required, form_data)
    self.checkPhoneIsValid(phone_fields)
    self.checkEmailIsValid(email_fields)
  end

  def self.checkRequiredFieldsHaveValues(required, form_data)
    required.each { |field|
      if form_data[field] && form_data[field].strip.empty?
        field = field.capitalize.gsub(/_/, " ")
        @@errors[field] = "#{field} is required for a valid request."
      end
    }
  end

  def self.checkPhoneIsValid(phone_fields)
    phone_fields.each do |field_name, field_value|
      if field_value && doesFieldHaveValue(field_value) && !(field_value =~ /^[\d|\s]+[\d|\s]*$/)
        field_name = field_name.capitalize.gsub(/_/, " ")
        @@errors[field_name] = "#{field_name} is a phone number field. Please enter only numbers and spaces."
      end
    end
  end

  def self.checkEmailIsValid(email_fields)
    email_fields.each do |field_name, field_value|
      if field_value && doesFieldHaveValue(field_value) && !(field_value =~ /^[\w\d]+[^@]*@[\w\d]+[^@]*\.[\w\d]+[^@]*$/)
        field_name = field_name.capitalize.gsub(/_/, " ")
        @@errors[field_name] = "#{field_name} is an email field. Please enter valid email like x@y.something."
      end
    end
  end

  def self.checkOptionalDateFieldsAreComplete(form_data, optional_date_fields)
    optional_date_fields.each do |arrayofday_month_year|
      day = form_data[arrayofday_month_year[1]]
      month = form_data[arrayofday_month_year[2]]
      year = form_data[arrayofday_month_year[3]]

      message = []
      if day.empty?
        message << arrayofday_month_year[1].capitalize.gsub(/_/, " ")
      end
      if month.empty?
        message << arrayofday_month_year[2].capitalize.gsub(/_/, " ")
      end
      if year.empty?
        message << arrayofday_month_year[3].capitalize.gsub(/_/, " ")
      end

      if message.length > 0 and message.length < 3
        fields_in_error_message = message.join(" and ")
        @@errors[arrayofday_month_year[0]] = "#{fields_in_error_message} not entered. Please enter complete date."
      end
    end

  end

  def self.doesFieldHaveValue(field_value)
    field_value && !field_value.strip.empty?
  end

  def self.validate_upload_file(field_name, upload_file)
    if upload_file[:tempfile].size > MAX_UPLOAD_FILE_SIZE_IN_BYTE
      @@errors[field_name] = "The attached file, #{upload_file[:filename]}, is bigger than 20MB size limitation."
    end
  end

  def self.validate_date_in_valid_range(date_field_name, day, month, year, form_data)
    if !form_data[day].empty? && !form_data[month].empty? && !form_data[year].empty?
      date_to_validate = form_data[day] + "-" + form_data[month] + "-" + form_data[year]
      begin
        Date.parse(date_to_validate)
      rescue
        @@errors[date_field_name] = "#{date_to_validate} is invalid. Please enter existing date."
        return nil
      end
    end
  end

  def self.validate_date_is_equal_or_greater_than_today(date_field_name, date, message)
    if date && date < Date.today
      @@errors[date_field_name] = message
    end
  end

  def self.validate_not_before_date_is_equal_or_greater_than_need_by(not_before, need_by, message)
    if not_before && need_by && not_before < need_by
      @@errors["Not_before"] = message
    end
  end
end
