class GeneralRequestsController <  ApplicationController
  def new
    @request = GeneralRequest.new
    @formdata = {}
    prepopulate_organisation_list
  end

  def create
    # what's this for??
    # params[:user_agent] = request.user_agent

    @request = GeneralRequest.new(params)

    load_client_and_organisations("zendesk_error_upon_submit")
    @formdata = @request.attributes

    if @request.valid?
      ticket = ZendeskRequest.raise_zendesk_request(@client, @formdata, "general")
      if ticket
        redirect_to acknowledge_path
      else
        return render "support/zendesk_error", :locals => {:error_string => "zendesk_error_upon_submit"}
      end
    else
      @errors = @request.errors
      render :new, :status => 400
    end
  end
end