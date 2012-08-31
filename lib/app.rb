require 'bundler'
Bundler.require

require_relative "zendesk_client"
require_relative "validations"
require_relative "helpers"

class App < Sinatra::Base


  get '/' do
    erb :landing
  end

  get '/acknowledge' do
    erb :acknowledge
  end

  # Content routing
  get '/new' do
    load_page("New Need", "content/new_need_message", "content/new", "content/contentlayout", params)
  end

  post '/new' do
    @errors = Guard.validationsForNewNeed(params)

    if @errors.empty?
      ticket = ZendeskClient.raise_zendesk_request(params, "new")
      if ticket
        redirect '/acknowledge'
      else
        @errors = Guard.fail_to_create_ticket
        load_page("New Need", "content/new_need_message", "content/new", "content/contentlayout", params)
      end
    else
      load_page("New Need", "content/new_need_message", "content/new", "content/contentlayout", params)
    end
  end

  get '/amend-content' do
    load_page("Content Change", "content/content_amend_message", "content/amend", "content/contentlayout", params)
  end

  post '/amend-content' do
    @errors = Guard.validationsForAmendContent(params)

    if @errors.empty?
      ticket = ZendeskClient::raise_zendesk_request(params, "amend-content")
      if ticket
        redirect '/acknowledge'
      else
        @errors = Guard.fail_to_create_ticket
        load_page("Content Change", "content/content_amend_message", "content/amend", "content/contentlayout", params)
      end
    else
      load_page("Content Change", "content/content_amend_message", "content/amend", "content/contentlayout", params)
    end
  end

#  User access routing
  get '/create-user' do
    load_page("Create New User", "useraccess/user_create_message", "useraccess/user", "useraccess/userlayout", params)
  end

  post '/create-user' do
    @errors = Guard.validationsForUserAccess(params)

    if @errors.empty?
      ticket= ZendeskClient::raise_zendesk_request(params, "create-user")
      if ticket
        redirect '/acknowledge'
      else
        @errors = Guard.fail_to_create_ticket
        load_page("Create New User", "useraccess/user_create_message", "useraccess/user", "useraccess/userlayout", params)
      end
    else
      load_page("Create New User", "useraccess/user_create_message", "useraccess/user", "useraccess/userlayout", params)
    end
  end

  get '/remove-user' do
    load_page("Remove User", "useraccess/user_remove_message", "useraccess/userremove", "useraccess/userlayout", params)
  end

  post '/remove-user' do
    @errors = Guard.validationsForDeleteUser(params)

    if @errors.empty?
        ticket = ZendeskClient::raise_zendesk_request(params, "remove-user")
      if ticket
        redirect '/acknowledge'
      else
        @errors = Guard.fail_to_create_ticket
        load_page("Remove User", "useraccess/user_remove_message", "useraccess/userremove", "useraccess/userlayout", params)
      end
    else
      load_page("Remove User", "useraccess/user_remove_message", "useraccess/userremove", "useraccess/userlayout", params)
    end
  end

  get '/reset-password' do
    load_page("Reset Password", "useraccess/user_password_reset_message", "useraccess/resetpassword", "useraccess/userlayout", params)
  end

  post '/reset-password' do
    @errors = Guard.validationsForUserAccess(params)

    if @errors.empty?
      ticket = ZendeskClient.raise_zendesk_request(params, "reset-password")
      if ticket
        redirect '/acknowledge'
      else
        load_page("Reset Password", "useraccess/user_password_reset_message", "useraccess/resetpassword", "useraccess/userlayout", params)
      end
    else
      load_page("Reset Password", "useraccess/user_password_reset_message", "useraccess/resetpassword", "useraccess/userlayout", params)
    end
  end

#  Campaigns routing
  get '/campaign' do
    load_page("Campaign", "campaigns/campaign_message", "campaigns/campaign", "campaigns/campaignslayout", params)
  end

  post '/campaign' do
    @errors = Guard.validationsForCampaign(params)

    if @errors.empty?
      ticket = ZendeskClient.raise_zendesk_request(params, "campaign")
      if ticket
        redirect '/acknowledge'
      else
        @errors = Guard.fail_to_create_ticket
        load_page("Campaign", "campaigns/campaign_message", "campaigns/campaign", "campaigns/campaignslayout", params)
      end
    else
      load_page("Campaign", "campaigns/campaign_message", "campaigns/campaign", "campaigns/campaignslayout", params)
    end
  end

  #Tech Issue routing
  get '/broken-link' do
    load_page("Broken Link", "tech-issues/message_broken_link", "tech-issues/broken_link", "tech-issues/tech_issue_layout", params)
  end

  post '/broken-link' do
    @errors = Guard.validationsForBrokenLink(params)

    if @errors.empty?
      ticket = ZendeskClient.raise_zendesk_request(params, "broken-link")
      if ticket
        redirect '/acknowledge'
      else
        load_page("Broken Link", "tech-issues/message_broken_link", "tech-issues/broken_link", "tech-issues/tech_issue_layout", params)
      end
    else
      load_page("Broken Link", "tech-issues/message_broken_link", "tech-issues/broken_link", "tech-issues/tech_issue_layout", params)
    end
  end

  get '/publish-tool' do
    load_page("Publishing Tool", "tech-issues/message_publish_tool", "tech-issues/publish_tool", "tech-issues/tech_issue_layout", params)
  end

  post '/publish-tool' do
    @errors = Guard.validationsForPublishTool(params)

    if @errors.empty?
      ticket = ZendeskClient.raise_zendesk_request(params, "publish-tool")
      if ticket
        redirect '/acknowledge'
      else
        @errors = Guard.fail_to_create_ticket
        load_page("Publishing Tool", "tech-issues/message_publish_tool", "tech-issues/publish_tool", "tech-issues/tech_issue_layout", params)
      end
    else
      load_page("Publishing Tool", "tech-issues/message_publish_tool", "tech-issues/publish_tool", "tech-issues/tech_issue_layout", params)
    end
  end
end
