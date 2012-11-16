require "zendesk_request"
require "zendesk_client"

class ApplicationController < ActionController::Base
  include GDS::SSO::ControllerMethods
  
  before_filter :authenticate_user!
  
  protect_from_forgery

  def new
    @request = new_request
    prepopulate_organisation_list
  end

  def create
    @request = parse_request_from_params
    if @request.valid?
      raise_ticket(zendesk_ticket_class.new(@request))
    else
      render :new, :status => 400
    end
  end

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

  def raise_ticket(ticket)
    load_client

    ticket = ZendeskRequest.raise_ticket(@client, ticket)

    if ticket
      redirect_to acknowledge_path
    else
      return render "support/zendesk_error", :locals => {:error_string => "zendesk_error_upon_submit"}
    end
  end

  def load_client_and_organisations(error_string)
    load_client
    load_organisations(error_string)
  end

  def load_client
    @client = ZendeskClient.get_client(logger)
  end

  def load_organisations(error_string)
    begin
      @organisations = ZendeskRequest.get_organisations(@client)
    rescue ZendeskError
      return render :"support/zendesk_error", :locals => {:error_string => error_string}
    end
  end

  def prepopulate_organisation_list
    load_client_and_organisations("zendesk_error_upon_new_form")
  end
end
