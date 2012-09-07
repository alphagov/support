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
  get '/new' do
    on_get("New Need", "content/new_need_message", "content/new")
  end

  post '/new' do
    @header = "New Need"
    @header_message = :"content/new_need_message"
    @template = "content/new"

    @errors = Guard.validationsForNewNeed(params)
    on_post(params, "new")
  end

  get '/amend-content' do
    on_get("Content Change", "content/content_amend_message", "content/amend")
  end

  post '/amend-content' do
    @header = "Content Change"
    @header_message = :"content/content_amend_message"
    @template = "content/amend"

    @errors = Guard.validationsForAmendContent(params)
    on_post(params, "amend-content")
  end

#  User access routing
  get '/create-user' do
    on_get("Create New User", "useraccess/user_create_message", "useraccess/user")
  end

  post '/create-user' do
    @header = "Create New User"
    @header_message = :"useraccess/user_create_message"
    @template = "useraccess/user"

    @errors = Guard.validationsForUserAccess(params)
    on_post(params, "create-user")
  end

  get '/remove-user' do
    on_get("Remove User", "useraccess/user_remove_message", "useraccess/userremove")
  end

  post '/remove-user' do
    @header = "Remove User"
    @header_message = :"useraccess/user_remove_message"
    @template = "useraccess/userremove"

    @errors = Guard.validationsForDeleteUser(params)
    on_post(params, "remove-user")
  end

  get '/reset-password' do
    on_get("Reset Password", "useraccess/user_password_reset_message", "useraccess/resetpassword")
  end

  post '/reset-password' do
    @header = "Reset Password"
    @header_message = :"useraccess/user_password_reset_message"
    @template = "useraccess/resetpassword"

    @errors = Guard.validationsForUserAccess(params)
    on_post(params, "reset-password")
  end

#  Campaigns routing
  get '/campaign' do
    on_get("Campaign", "campaigns/campaign_message", "campaigns/campaign")
  end

  post '/campaign' do
    @header = "Reset Password"
    @header_message = :"campaigns/campaign_message"
    @template = "campaigns/campaign"

    @errors = Guard.validationsForCampaign(params)
    on_post(params, "campaign")
  end

  #Tech Issue routing
  get '/broken-link' do
    on_get("Broken Link", "tech-issues/message_broken_link", "tech-issues/broken_link")
  end

  post '/broken-link' do
    params[:user_agent] = @request.user_agent
    @header = "Broken Link"
    @header_message = :"tech-issues/message_broken_link"
    @template = "tech-issues/broken_link"

    @errors = Guard.validationsForBrokenLink(params)
    on_post(params, "broken-link")
  end

  get '/publish-tool' do
    on_get("Publishing Tool", "tech-issues/message_publish_tool", "tech-issues/publish_tool")
  end

  post '/publish-tool' do
    params[:user_agent] = @request.user_agent
    @header = "Publishing Tool"
    @header_message = :"tech-issues/message_publish_tool"
    @template = "tech-issues/publish_tool"

    @errors = Guard.validationsForPublishTool(params)
    on_post(params, "publish-tool")
  end

  def on_get(head, head_message_form, template)
    @departments = ZendeskClient.get_departments
    @header = head
    @header_message = :"#{head_message_form}"
    @formdata = {}

    erb :"#{template}", :layout => :formlayout
  end

  def on_post(params, route)
    @departments = ZendeskClient.get_departments
    @formdata = params

    if @errors.empty?
      ticket = ZendeskClient.raise_zendesk_request(params, route)
      if ticket
        redirect '/acknowledge'
      else
        @errors = Guard.fail_to_create_ticket
        erb :"#{@template}", :layout => :formlayout
      end
    else
      erb :"#{@template}", :layout => :formlayout
    end
  end

end
