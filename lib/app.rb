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
    #url_add = url_old = url_remove = ""
    #if params[:url_add1] || params[:url_add2] || params[:url_add3]
    #  url_add = "\n\n [the url(s) for add content] \n" + build_full_url_path(params[:url_add1]) + "\n" +
    #      build_full_url_path(params[:url_add2]) + "\n" +
    #      build_full_url_path(params[:url_add3]) + "\n"
    #
    #end
    #
    #if params[:url_old1] || params[:url_old2] || params[:url_old3]
    #  url_old = "\n\n [the url(s) for old content] \n" + build_full_url_path(params[:url_old1]) + "\n" +
    #      build_full_url_path(params[:url_old2]) + "\n" +
    #      build_full_url_path(params[:url_old3]) + "\n"
    #end
    #
    #if params[:place_to_remove1] || params[:place_to_remove2] || params[:place_to_remove3]
    #
    #  url_remove = "\n\n [the url(s) for remove the content] \n"+ build_full_url_path(params[:place_to_remove1]) + "\n" +
    #      build_full_url_path(params[:place_to_remove2]) + "\n" +
    #      build_full_url_path(params[:place_to_remove3]) + "\n"
    #end
    #
    #comment = "[added content]\n" + params[:add_content] + url_add +"\n\n" + "[old content]\n" + params[:old_content] + url_old + "\n\n" + "[new content]\n"+ params[:new_content] + "\n\n" + "[remove content]\n"+ params[:remove_content] + url_remove + "\n\n" + params[:additional]
    #subject = "Content change request"
    #tag = "content_change"
    #
    #need_by, not_before = build_date(params)
    #params["need_by"] = need_by
    #params[not_before] = not_before

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
