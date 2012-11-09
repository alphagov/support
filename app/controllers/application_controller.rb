require "zendesk_request"
require "zendesk_client"

class ApplicationController < ActionController::Base
  include GDS::SSO::ControllerMethods
  
  before_filter :authenticate_user!
  
  protect_from_forgery

  private

  def on_get(template)
    load_client_and_organisations("zendesk_error_upon_new_form")

    @formdata = {}
    render :"#{template}", :layout => "application"
  end

  def on_post(params, route)
    load_client_and_organisations("zendesk_error_upon_submit")
    @formdata = params

    if @errors.empty?
      ticket = ZendeskRequest.raise_zendesk_request(@client, params, route)
      if ticket
        redirect_to '/acknowledge'
      else
        return render :"support/zendesk_error", :locals => {:error_string => "zendesk_error_upon_submit"}
      end
    else
      render :"#{@template}", :layout => "application", :status => 400
    end
  end

  def load_client_and_organisations(error_string)
    begin
      @client = ZendeskClient.get_client(logger)
      @organisations = ZendeskRequest.get_organisations(@client)
    rescue ZendeskError
      return render :"support/zendesk_error", :locals => {:error_string => error_string}
    end
  end

  def prepopulate_organisation_list
    begin
      @client = ZendeskClient.get_client(logger)
      @organisations = ZendeskRequest.get_organisations(@client)
    rescue ZendeskError
      return render :"support/zendesk_error",  :locals => {:error_string => "zendesk_error_upon_new_form"}
    end
  end
end
