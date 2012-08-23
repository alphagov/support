require 'bundler'
Bundler.require

require_relative "zendesk_client"

class App < Sinatra::Base

  get '/' do
    erb :landing
  end

  get '/acknowledge' do
    erb :acknowledge
  end

  get '/add-content' do
    @departments = ZendeskClient.get_departments
    @header = "Add Content"
    @header_message = :content_add_message
    erb :add, :layout => :contentlayout
  end

  get '/amend-content' do
    @departments = ZendeskClient.get_departments
    @header = "Amend Content"
    @header_message = :content_amend_message
    erb :amend, :layout => :contentlayout
  end

  get '/delete-content' do
    @departments = ZendeskClient.get_departments
    @header = "Delete Content"
    @header_message = :content_delete_message
    erb :delete, :layout => :contentlayout
  end



  post '/add-content' do
    url = build_full_url_path(params[:target_url])
    comment = url + "\n\n" + params[:add_content] + "\n\n" + params[:additional]
    subject = "Add Content"
    tag = "add_content"
    need_by = params[:need_by_day] + "/"  + params[:need_by_month] + "/" + params[:need_by_year]
    not_before = params[:not_before_day] + "/"  + params[:not_before_month] + "/" + params[:not_before_year]
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by,not_before)
    redirect '/acknowledge'
  end

  post '/amend-content' do
    url = build_full_url_path(params[:target_url])
    comment = url + "\n\n" + "[old content]\n" + params[:old_content] + "\n\n" + "[new content]\n"+params[:new_content] + "\n\n" + params[:place_to_remove] + "\n\n" + params[:additional]
    subject = "Amend Content"
    tag = "amend_content"
    need_by = params[:need_by_day] + "/"  + params[:need_by_month] + "/" + params[:need_by_year]
    not_before = params[:not_before_day] + "/"  + params[:not_before_month] + "/" + params[:not_before_year]
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by,not_before)
    redirect '/acknowledge'
  end

  post '/delete-content' do
    url = build_full_url_path(params[:target_url])
    comment = url + "\n\n" + params[:additional]
    subject = "Delete Content"
    tag = "delete_content"
    need_by = params[:need_by_day] + "/"  + params[:need_by_month] + "/" + params[:need_by_year]
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment,need_by,"")
    redirect '/acknowledge'
  end


#  User access routing

  get '/create-user' do
    @departments = ZendeskClient.get_departments
    @header = "Create New User"
    @header_message = :user_create_message
    erb :user, :layout => :userlayout
  end

  post '/create-user' do
    subject = "Create New User"
    tag = "new_user"
    comment = params[:user_name] + "\n\n" + params[:user_email]+ "\n\n" + params[:additional]
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, nil, nil)
    redirect '/acknowledge'
  end

  get '/delete-user' do
    @departments = ZendeskClient.get_departments
    @header = "Delete User"
    @header_message = :user_delete_message
    erb :userdelete, :layout => :userlayout
  end

  post '/delete-user' do
    subject = "Delete User"
    tag = "delete_user"
    comment = params[:user_name] + "\n\n" + params[:user_email]+ "\n\n" + params[:additional]
    not_before = params[:not_before_day] + "/"  + params[:not_before_month] + "/" + params[:not_before_year]
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, nil, not_before)
    redirect '/acknowledge'
  end

  get '/reset-password' do
    @departments = ZendeskClient.get_departments
    @header = "Reset Password"
    @header_message = :user_password_reset_message
    erb :resetpassword, :layout => :userlayout
  end

  post '/reset-password' do
    subject = "Reset Password"
    tag = "password_reset"
    comment = params[:user_name] + "\n\n" + params[:user_email]+ "\n\n" + params[:additional]
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, nil, nil)
    redirect '/acknowledge'
  end


#  Campaigns

  get '/campaign' do
    @departments = ZendeskClient.get_departments
    @header = "Campaign"
    @header_message = :campaign_message
    erb :campaign, :layout => :campaignslayout
  end

  post '/campaign' do
    subject = "Campaign"
    tag = "campaign"
    comment = params[:name] + "\n\n" + params[:erg_number] + params[:company] + "\n\n" + params[:description] + "\n\n" + params[:target_url]
    need_by = params[:need_by_day] + "/"  + params[:need_by_month] + "/" + params[:need_by_year]
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by, nil)
    redirect '/acknowledge'

  end

  #Tech Issue
  get '/broken-link' do
    @departments = ZendeskClient.get_departments
    @header = "Broken Link"
    @header_message = :message_broken_link
    erb :broken_link, :layout => :tech_issue_layout
  end

  post '/broken-link' do
    subject = "Broken Link"
    tag = "broken_link"
    url = build_full_url_path(params[:target_url])
    comment = url + "\n\n" + params[:additional]
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, nil, nil)
    redirect '/acknowledge'
  end

  get '/publish-tool' do
    @departments = ZendeskClient.get_departments
    @header = "Publishing Tool"
    @header_message = :message_publish_tool
    erb :publish_tool, :layout => :tech_issue_layout
  end

  post '/publish-tool' do
    subject = "Publishing Tool"
    tag = "publishing_tool"
    url = build_full_url_path(params[:target_url])
    comment = params[:username] + "\n\n" + url + "\n\n" + params[:additional]
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, nil, nil)
    redirect '/acknowledge'
  end

  def self.build_full_url_path(partial_path)
    url = "http://gov.uk/"+ partial_path
  end
end