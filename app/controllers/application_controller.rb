require "zendesk_request"
require "zendesk_client"

class ApplicationController < ActionController::Base
  include GDS::SSO::ControllerMethods
  
  before_filter :authenticate_user!
  
  protect_from_forgery

  private

  def on_get(template)
    begin
      @client = ZendeskClient.get_client(logger)
      @organisations = ZendeskRequest.get_organisations(@client)
    rescue ZendeskError
      return render :"support/zendesk_connection_error", :layout => "application"
    end

    @formdata = {}
    render :"#{template}", :layout => "application"
  end

  def on_post(params, route)
    begin
      @client = ZendeskClient.get_client(logger)
      @organisations = ZendeskRequest.get_organisations(@client)
    rescue ZendeskError
      return render :"support/zendesk_error", :layout => "application"
    end
    @formdata = params

    if @errors.empty?
      ticket = ZendeskRequest.raise_zendesk_request(@client, params, route)
      if ticket
        redirect_to '/acknowledge'
      else
        return render :"support/zendesk_error", :layout => "application"
      end
    else
      render :"#{@template}", :layout => "application", :status => 400
    end
  end

  def prepopulate_organisation_list
    begin
      @client = ZendeskClient.get_client(logger)
      @organisations = ZendeskRequest.get_organisations(@client)
    rescue ZendeskError
      return render :"support/zendesk_connection_error", :layout => "application"
    end
  end
end
