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
    erb :add, :layout => :contentlayout
  end

  get '/amend-content' do
    @departments = ZendeskClient.get_departments
    @header = "Amend Content"
    erb :amend, :layout => :contentlayout
  end

  get '/delete-content' do
    @departments = ZendeskClient.get_departments
    @header = "Delete Content"
    erb :delete, :layout => :contentlayout
  end

  get '/emergency' do
    @header = "Emergency Publishing"
    erb :workinprogress
  end

  get '/tech-issues' do
    erb :workinprogress
  end

  post '/add-content' do
    url = "http://gov.uk/"+ params[:target_url]
    comment = url + "\n\n" + params[:new_content] + "\n\n" + params[:additional]
    subject = "Add Content"
    tag = "add_content"
    need_by = params[:need_by_day] + "/"  + params[:need_by_month] + "/" + params[:need_by_year]
    not_before = params[:not_before_day] + "/"  + params[:not_before_month] + "/" + params[:not_before_year]
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by,not_before)
    redirect '/acknowledge'
  end

  post '/amend-content' do
    url = "http://gov.uk/"+ params[:target_url]
    comment = url + "\n\n" + "[old content]\n" + params[:old_content] + "\n\n" + "[new content]\n"+params[:new_content] + "\n\n" + params[:place_to_remove] + "\n\n" + params[:additional]
    subject = "Amend Content"
    tag = "amend_content"
    need_by = params[:need_by_day] + "/"  + params[:need_by_month] + "/" + params[:need_by_year]
    not_before = params[:not_before_day] + "/"  + params[:not_before_month] + "/" + params[:not_before_year]
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by,not_before)
    redirect '/acknowledge'
  end

  post '/delete-content' do
    url = "http://gov.uk/"+ params[:target_url]
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
    erb :userdelete, :layout => :userlayout
  end

  post '/delete-user' do
    subject = "Delete User"
    tag = "remove_user"
    comment = params[:user_name] + "\n\n" + params[:user_email]+ "\n\n" + params[:additional]
    not_before = params[:not_before_day] + "/"  + params[:not_before_month] + "/" + params[:not_before_year]
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, nil, not_before)
    redirect '/acknowledge'
  end

  get '/reset-password' do
    @departments = ZendeskClient.get_departments
    @header = "Reset Password"
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
    erb :campaign, :layout => :campaignslayout
  end

  post '/campaign' do
    subject = "Campaign"
    tag = "campaign"
    comment = params[:name] + "\n\n" + params[:company] + "\n\n" + params[:description] + "\n\n" + params[:target_url]
    need_by = params[:need_by_day] + "/"  + params[:need_by_month] + "/" + params[:need_by_year]
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, need_by, nil)
    redirect '/acknowledge'

  end

end