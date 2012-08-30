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
    initialize_data("New Need", "content/new_need_message")
    erb :"content/new", :layout => :"content/contentlayout"
  end

  post '/new' do
    comment = params[:additional]
    subject = "New need"
    tag = "new_need"
    need_by = params[:need_by_day] + "/" + params[:need_by_month] + "/" + params[:need_by_year]
    params["need_by"] = need_by
    not_before = params[:not_before_day] + "/" + params[:not_before_month] + "/" + params[:not_before_year]

    @errors = Guard.validationsForNewNeed(params)
    if @errors.empty?
      ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by, not_before)
      redirect '/acknowledge'
    else
      initialize_data("New Need", "content/new_need_message")
      @formdata = params
      erb :"content/new", :layout => :"content/contentlayout"
    end
  end

  get '/amend-content' do
    initialize_data("Content Change", "content/content_amend_message")
    erb :"content/amend", :layout => :"content/contentlayout"
  end

  post '/amend-content' do
    url = build_full_url_path(params[:url_add1]) + "\n" +
        build_full_url_path(params[:url_add2]) + "\n" +
        build_full_url_path(params[:url_add3]) + "\n" +
        build_full_url_path(params[:url_add3]) + "\n" +
        build_full_url_path(params[:url_old1]) + "\n" +
        build_full_url_path(params[:url_old2]) + "\n" +
        build_full_url_path(params[:url_old3]) + "\n" +
        build_full_url_path(params[:place_to_remove1]) + "\n" +
        build_full_url_path(params[:place_to_remove2]) + "\n" +
        build_full_url_path(params[:place_to_remove3]) + "\n" +

    comment = url + "\n\n" + "[old content]\n" + params[:old_content] + "\n\n" + "[new content]\n"+params[:new_content] + "\n\n" + params[:place_to_remove] + "\n\n" + params[:additional]
    subject = "Content change request"
    tag = "content_change"

    need_by, not_before = build_date(params)
    params["need_by"] = need_by
    params[not_before] = not_before

    @errors = Guard.validationsForAmendContent(params)
    if @errors.empty?
      if params[:uploaded_data] || params[:upload_amend]
        create_ticket_with_uploaded_file(params, subject, tag, comment, need_by, not_before)
      else
        ZendeskClient::raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by, not_before)
      end
      redirect '/acknowledge'
    else
      initialize_data("Content Change", "content/content_amend_message")
      @formdata = params
      erb :"content/amend", :layout => :"content/contentlayout"
    end
  end

#  User access routing
  get '/create-user' do
    initialize_data("Create New User", "useraccess/user_create_message")
    erb :"useraccess/user", :layout => :"useraccess/userlayout"
  end

  post '/create-user' do
    subject = "Create New User"
    tag = "new_user"
    comment = params[:user_name] + "\n\n" + params[:user_email]+ "\n\n" + params[:additional]
    need_by, not_before = build_date(params)

    @errors = Guard.validationsForUserAccess(params)
    if @errors.empty?
      if params[:uploaded_data]
        create_ticket_with_uploaded_file(params, subject, tag, comment, need_by, not_before)
      else
        ZendeskClient::raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by, not_before)
      end
      redirect '/acknowledge'
    else
      initialize_data("Create New User", "useraccess/user_create_message")
      @formdata = params
      erb :"useraccess/user", :layout => :"useraccess/userlayout"
    end
  end

  get '/remove-user' do
    initialize_data("Remove User", "useraccess/user_remove_message")
    erb :"useraccess/userremove", :layout => :"useraccess/userlayout"
  end

  post '/remove-user' do
    subject = "Remove user"
    tag = "remove_user"
    comment = params[:user_name] + "\n\n" + params[:user_email]+ "\n\n" + params[:additional]
    need_by, not_before = build_date(params)
    params[not_before] = not_before

    @errors = Guard.validationsForDeleteUser(params)

    if @errors.empty?
      if params[:uploaded_data]
        create_ticket_with_uploaded_file(params, subject, tag, comment, need_by, not_before)
      else
        ZendeskClient::raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by, not_before)
      end
      redirect '/acknowledge'
    else
      initialize_data("Remove User", "useraccess/user_remove_message")
      @formdata = params
      erb :"useraccess/userremove", :layout => :"useraccess/userlayout"
    end
  end

  get '/reset-password' do
    initialize_data("Reset Password", "useraccess/user_password_reset_message")
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
      initialize_data("Reset Password", "useraccess/user_password_reset_message")
      @formdata = params
      erb :"useraccess/resetpassword", :layout => :"useraccess/userlayout"
    end
  end

#  Campaigns routing
  get '/campaign' do
    initialize_data("Campaign", "campaigns/campaign_message")
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
      initialize_data("Campaign", "campaigns/campaign_message")
      @formdata = params
      erb :"campaigns/campaign", :layout => :"campaigns/campaignslayout"
    end
  end

  #Tech Issue routing
  get '/broken-link' do
    initialize_data("Broken Link", "tech-issues/message_broken_link")
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
      initialize_data("Broken Link", "tech-issues/message_broken_link")
      @formdata = params
      erb :"tech-issues/broken_link", :layout => :"tech-issues/tech_issue_layout"
    end
  end

  get '/publish-tool' do
    initialize_data("Publishing Tool", "tech-issues/message_publish_tool")
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
      initialize_data("Publishing Tool", "tech-issues/message_publish_tool")
      @formdata = params
      erb :"tech-issues/publish_tool", :layout => :"tech-issues/tech_issue_layout"
    end
  end
end
