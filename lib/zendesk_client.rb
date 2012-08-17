class ZendeskClient

  @client = ZendeskAPI::Client.new { |config|
    config.url = "https://govuk.zendesk.com/api/v2/"
    config.username = "zd-api-govt@digital.cabinet-office.gov.uk"
    config.password = "12345"
  }


  def self.get_departments
    departments_hash = {"Select Department" => ""}
    @client.ticket_fields.find(:id => '21494928').custom_field_options.each { |tf| departments_hash[tf.name] = tf.value }
    departments_hash
  end

  def self.raise_zendesk_request(subject, tag, name, email, dep, job, phone, comment, added_date, not_before_date)
    phone = remove_space_from_phone_number(phone)
    @client.ticket.create(
        :subject => subject,
        :description => "testing for email",
        :priority => "normal",
        :requester => {"locale_id" => 1, "name" => name, "email" => email},
        :fields => [{"id" => "21494928", "value" => dep},
                    {"id" => "21487987", "value" => job},
                    {"id" => "21471291", "value" => phone},
                    {"id" => "21485833", "value" => added_date},
                    {"id" => "21502036", "value" => not_before_date}],
        :comment => {:value => comment},
        :tags => [tag])
  end



  private

  def self.remove_space_from_phone_number(number)
    number.gsub(/\s+/, "")
  end

end
