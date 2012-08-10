require 'sinatra'
require 'zendesk_api'

class ZendeskHelper

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

  def self.rise_Zendesk_request(name, email, dep, job, phone)
    @client.ticket.create(
        :subject => "Test Ticket",
        :description => "testing for email",
        :priority => "normal",
        :requester => {"locale_id" => 1, "name" => name, "email" => email},
        :fields => [{"id" => "21494928", "value" => dep}, {"id" => "21487987", "value" => job}, {"id" => "21471291", "value" => phone}])
  end
end


get '/form' do
  departments = ZendeskHelper.get_departments
  erb :form_template, :locals => {:departments => departments}
end

get '/acknowledge' do
  erb :acknowledge
end

post '/form' do
  ZendeskHelper.rise_Zendesk_request(params[:name], params[:email], params[:dep], params[:job_title], params[:phone_number])
  redirect '/acknowledge'
end


