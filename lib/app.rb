require 'bundler'
Bundler.require

require_relative "zendesk_client"
require_relative "validations"

class App < Sinatra::Base

  get '/' do
    erb :landing
  end

  get '/acknowledge' do
    erb :acknowledge
  end

  # Content routing
  get '/add-content' do
    @departments = ZendeskClient.get_departments
    @header = "Add Content"
    @header_message = :"content/content_add_message"
    @formdata = {}
    erb :"content/add", :layout => :"content/contentlayout"
  end

  get '/amend-content' do
    @departments = ZendeskClient.get_departments
    @header = "Amend Content"
    @header_message = :"content/content_amend_message"
    @formdata = {}
    erb :"content/amend", :layout => :"content/contentlayout"
  end

  get '/delete-content' do
    @departments = ZendeskClient.get_departments
    @header = "Delete Content"
    @header_message = :"content/content_delete_message"
    @formdata = {}
    erb :"content/delete", :layout => :"content/contentlayout"
  end

  post '/add-content' do
    url = build_full_url_path(params[:url])
    comment = url + "\n\n" + params[:add_content] + "\n\n" + params[:additional]
    subject = "Add Content"
    tag = "add_content"
    need_by = params[:need_by_day] + "/" + params[:need_by_month] + "/" + params[:need_by_year]
    params["need_by"] = need_by
    not_before = params[:not_before_day] + "/" + params[:not_before_month] + "/" + params[:not_before_year]

    @errors = Guard.validationsForAddContent(params)

    if @errors.empty?
      ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by, not_before)
      redirect '/acknowledge'
    else
      @departments = ZendeskClient.get_departments
      @header = "Add Content"
      @header_message = :"content/content_add_message"
      @formdata = params
      erb :"content/add", :layout => :"content/contentlayout"
    end
  end

  post '/amend-content' do
    url = build_full_url_path(params[:url])
    comment = url + "\n\n" + "[old content]\n" + params[:old_content] + "\n\n" + "[new content]\n"+params[:new_content] + "\n\n" + params[:place_to_remove] + "\n\n" + params[:additional]
    subject = "Amend Content"
    tag = "amend_content"
    need_by = params[:need_by_day] + "/" + params[:need_by_month] + "/" + params[:need_by_year]
    params["need_by"] = need_by
    not_before = params[:not_before_day] + "/" + params[:not_before_month] + "/" + params[:not_before_year]
    params[not_before] = not_before

    @errors = Guard.validationsForAmendContent(params)

    if @errors.empty?
      ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by, not_before)
      redirect '/acknowledge'
    else
      @departments = ZendeskClient.get_departments
      @header = "Amend Content"
      @header_message = :"content/content_amend_message"
      @formdata = params
      erb :"content/amend", :layout => :"content/contentlayout"
    end
  end

  post '/delete-content' do
    url = build_full_url_path(params[:url])
    comment = url + "\n\n" + params[:additional]
    subject = "Delete Content"
    tag = "delete_content"
    need_by = params[:need_by_day] + "/" + params[:need_by_month] + "/" + params[:need_by_year]
    params["need_by"] = need_by

    @errors = Guard.validationsForDeleteContent(params)
    
    if @errors.empty?
      ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by, "")
      redirect '/acknowledge'
    else
      @departments = ZendeskClient.get_departments
      @header = "Delete Content"
      @header_message = :"content/content_delete_message"
      @formdata = params
      erb :"content/delete", :layout => :"content/contentlayout"
    end
  end


#  User access routing
  get '/create-user' do
    @departments = ZendeskClient.get_departments
    @header = "Create New User"
    @header_message = :"useraccess/user_create_message"
    @formdata = {}
    erb :"useraccess/user", :layout => :"useraccess/userlayout"
  end

  post '/create-user' do
    subject = "Create New User"
    tag = "new_user"
    comment = params[:user_name] + "\n\n" + params[:user_email]+ "\n\n" + params[:additional]

    @errors = Guard.validationsForUserAccess(params)
    
    if @errors.empty?
      ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, nil, nil)
      redirect '/acknowledge'
    else
      @departments = ZendeskClient.get_departments
      @header = "Create New User"
      @header_message = :"useraccess/user_create_message"
      @formdata = params
      erb :"useraccess/user", :layout => :"useraccess/userlayout"
    end
  end

  get '/delete-user' do
    @departments = ZendeskClient.get_departments
    @header = "Delete User"
    @header_message = :"useraccess/user_delete_message"
    @formdata = {}
    erb :"useraccess/userdelete", :layout => :"useraccess/userlayout"
  end

  post '/delete-user' do
    subject = "Delete User"
    tag = "delete_user"
    comment = params[:user_name] + "\n\n" + params[:user_email]+ "\n\n" + params[:additional]
    not_before = params[:not_before_day] + "/" + params[:not_before_month] + "/" + params[:not_before_year]
    params[not_before] = not_before

    @errors = Guard.validationsForDeleteUser(params)

    if @errors.empty?
      ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, nil, not_before)
      redirect '/acknowledge'
    else
      @departments = ZendeskClient.get_departments
      @header = "Delete User"
      @header_message = :"useraccess/user_delete_message"
      @formdata = params
      erb :"useraccess/userdelete", :layout => :"useraccess/userlayout"
    end
  end

  get '/reset-password' do
    @departments = ZendeskClient.get_departments
    @header = "Reset Password"
    @header_message = :"useraccess/user_password_reset_message"
    @formdata = {}
    erb :"useraccess/resetpassword", :layout => :"useraccess/userlayout"
  end

  post '/reset-password' do
    subject = "Reset Password"
    tag = "password_reset"
    comment = params[:user_name] + "\n\n" + params[:user_email]+ "\n\n" + params[:additional]

    @errors = Guard.validationsForUserAccess(params)
    
    if @errors.empty?
      ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, nil, nil)
      redirect '/acknowledge'
    else
      @departments = ZendeskClient.get_departments
      @header = "Reset Password"
      @header_message = :"useraccess/user_password_reset_message"
      @formdata = params
      erb :"useraccess/resetpassword", :layout => :"useraccess/userlayout"
    end
  end


#  Campaigns routing

  get '/campaign' do
    @departments = ZendeskClient.get_departments
    @header = "Campaign"
    @header_message = :"campaigns/campaign_message"
    @formdata = {}
    erb :"campaigns/campaign", :layout => :"campaigns/campaignslayout"
  end

  post '/campaign' do
    subject = "Campaign"
    tag = "campaign"
    comment = params[:campaign_name] + "\n\n" + params[:erg_number] + params[:company] + "\n\n" + params[:description] + "\n\n" + params[:url]
    need_by = params[:need_by_day] + "/" + params[:need_by_month] + "/" + params[:need_by_year]
    params["need_by"] = need_by

    @errors = Guard.validationsForCampaign(params)

    if @errors.empty?
      ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by, nil)
      redirect '/acknowledge'
    else
      @departments = ZendeskClient.get_departments
      @header = "Campaign"
      @header_message = :"campaigns/campaign_message"
      @formdata = params
      erb :"campaigns/campaign", :layout => :"campaigns/campaignslayout"
    end

  end

  #Tech Issue routing
  get '/broken-link' do
    @departments = ZendeskClient.get_departments
    @header = "Broken Link"
    @header_message = :"tech-issues/message_broken_link"
    @formdata = {}
    erb :"tech-issues/broken_link", :layout => :"tech-issues/tech_issue_layout"
  end

  post '/broken-link' do
    subject = "Broken Link"
    tag = "broken_link"
    url = build_full_url_path(params[:url])
    comment = url + "\n\n" + params[:additional]

    @errors = Guard.validationsForBrokenLink(params)

    if @errors.empty?
      ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, nil, nil)
      redirect '/acknowledge'
    else
      @departments = ZendeskClient.get_departments
      @header = "Broken Link"
      @header_message = :"tech-issues/message_broken_link"
      @formdata = params
      erb :"tech-issues/broken_link", :layout => :"tech-issues/tech_issue_layout"
    end
  end

  get '/publish-tool' do
    @departments = ZendeskClient.get_departments
    @header = "Publishing Tool"
    @header_message = :"tech-issues/message_publish_tool"
    @formdata = {}
    erb :"tech-issues/publish_tool", :layout => :"tech-issues/tech_issue_layout"
  end

  post '/publish-tool' do
    subject = "Publishing Tool"
    tag = "publishing_tool"
    url = build_full_url_path(params[:url])
    comment = params[:username] + "\n\n" + url + "\n\n" + params[:additional]

    @errors = Guard.validationsForPublishTool(params)
    
    if @errors.empty?
      ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, nil, nil)
      redirect '/acknowledge'
    else
      @departments = ZendeskClient.get_departments
      @header = "Publishing Tool"
      @header_message = :"tech-issues/message_publish_tool"
      @formdata = params
      erb :"tech-issues/publish_tool", :layout => :"tech-issues/tech_issue_layout"
    end

  end

  def build_full_url_path(partial_path)
    url = "http://gov.uk/"+ partial_path
  end
end
