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
    comment = params[:additional]
    subject = "New need"
    tag = "new_need"
    need_by = params[:need_by_day] + "/" + params[:need_by_month] + "/" + params[:need_by_year]
    params["need_by"] = need_by
    not_before = params[:not_before_day] + "/" + params[:not_before_month] + "/" + params[:not_before_year]

    @errors = Guard.validationsForNewNeed(params)

    if @errors.empty?
      ticket = ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by, not_before)
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
    url_add_array = [params[:url_add1], params[:url_add2], params[:url_add3]]
    url_old_array = [params[:url_old1], params[:url_old2], params[:url_add3]]
    url_remove_array = [params[:place_to_remove1], params[:place_to_remove2], params[:place_to_remove3]]
    url_add = url_old = url_remove = ""
    url_add_array.each{|au| url_add += au.empty?? au : build_full_url_path(au) + "\n"}
    url_old_array.each{|ou| url_old += ou.empty?? ou : build_full_url_path(ou) + "\n"}
    url_remove_array.each{|ru| url_remove += ru.empty?? ru : build_full_url_path(ru) + "\n"}

    comment = (params[:add_content].empty?? "" : "[added content]\n" + params[:add_content] + "\n\n") +
        (url_add.empty?? "" : "[url(s) for adding content]\n" +url_add +"\n\n") +
        (params[:old_content].empty?? "" : "[old content]\n" + params[:old_content] + "\n\n") +
        (url_old.empty?? "" :"[url(s) for old content]\n" + url_old + "\n\n" )+
        (params[:new_content].empty?? "" : "[new content]\n"+ params[:new_content] + "\n\n") +
        (params[:remove_content].empty?? "" : "[remove content]\n"+ params[:remove_content] + "\n\n") +
        (url_remove.empty?? "" : "[url(s) for removing content]\n" + url_remove + "\n\n") +
        (params[:additional].empty?? "" : "[additional]\n" + params[:additional])

    subject = "Content change request"
    tag = "content_change"

    need_by, not_before = build_date(params)
    params["need_by"] = need_by
    params[not_before] = not_before

    @errors = Guard.validationsForAmendContent(params)

    if @errors.empty?
      if params[:uploaded_data] || params[:upload_amend]
        ticket = create_ticket_with_uploaded_file(params, subject, tag, comment, need_by, not_before)
      else
        ticket = ZendeskClient::raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by, not_before)
      end
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
    subject = "Create New User"
    tag = "new_user"
    comment = params[:user_name] + "\n\n" + params[:user_email]+ "\n\n" + params[:additional]
    need_by, not_before = build_date(params)

    @errors = Guard.validationsForUserAccess(params)

    if @errors.empty?
      if params[:uploaded_data]
        ticket = create_ticket_with_uploaded_file(params, subject, tag, comment, need_by, not_before)
      else
        ticket= ZendeskClient::raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by, not_before)
      end
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
    subject = "Remove user"
    tag = "remove_user"
    comment = params[:user_name] + "\n\n" + params[:user_email]+ "\n\n" + params[:additional]
    need_by, not_before = build_date(params)
    params[not_before] = not_before

    @errors = Guard.validationsForDeleteUser(params)

    if @errors.empty?
      if params[:uploaded_data]
        ticket = create_ticket_with_uploaded_file(params, subject, tag, comment, need_by, not_before)
      else
        ticket = ZendeskClient::raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by, not_before)
      end
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
    subject = "Reset Password"
    tag = "password_reset"
    comment = params[:user_name] + "\n\n" + params[:user_email]+ "\n\n" + params[:additional]

    @errors = Guard.validationsForUserAccess(params)

    if @errors.empty?
      ticket = ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, nil, nil)
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
    subject = "Campaign"
    tag = "campaign"
    comment = params[:campaign_name] + "\n\n" + params[:erg_number] + "\n\n" + params[:company] + "\n\n" + params[:description] + "\n\n" + params[:url]
    need_by = params[:need_by_day] + "/" + params[:need_by_month] + "/" + params[:need_by_year]
    params["need_by"] = need_by

    @errors = Guard.validationsForCampaign(params)
    if @errors.empty?
      ticket = ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by, nil)
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
    subject = "Broken Link"
    tag = "broken_link"
    url = build_full_url_path(params[:url])
    comment = url + "\n\n" + params[:additional]

    @errors = Guard.validationsForBrokenLink(params)

    if @errors.empty?
      ticket = ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, nil, nil)
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
    subject = "Publishing Tool"
    tag = "publishing_tool"
    url = build_full_url_path(params[:url])
    comment = params[:username] + "\n\n" + url + "\n\n" + params[:additional]

    @errors = Guard.validationsForPublishTool(params)

    if @errors.empty?
      ticket = ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, nil, nil)
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
