require 'general_request_zendesk_ticket'

class GeneralRequestsController <  ApplicationController
  def new
    @request = GeneralRequest.new
    @formdata = {}
    prepopulate_organisation_list
  end

  def create
    params[:user_agent] = request.user_agent

    @request = GeneralRequest.new(params[:general_request])

    load_client_and_organisations("zendesk_error_upon_submit")

    if @request.valid?
      ticket = ZendeskRequest.raise_ticket(@client, GeneralRequestZendeskTicket.new(@request.attributes))
      if ticket
        redirect_to acknowledge_path
      else
        return render "support/zendesk_error", :locals => {:error_string => "zendesk_error_upon_submit"}
      end
    else
      render :new, :status => 400
    end
  end
end