require 'bundler'
Bundler.require

require "sinatra/content_for"
require_relative "zendesk_client"

class App < Sinatra::Base
  helpers Sinatra::ContentFor

  get '/feedback' do
    erb :main
  end

  get '/acknowledge' do
    erb :acknowledge
  end

  get '/new' do
    @departments = ZendeskClient.get_departments
    @header = "New Content"
    erb :new, :layout => :contentlayout
  end

  get '/amend' do
    @departments = ZendeskClient.get_departments
    @header = "Amend Content"
    erb :amend, :layout => :contentlayout
  end

  get '/delete' do
    @departments = ZendeskClient.get_departments
    @header = "Delete Content"
    erb :delete, :layout => :contentlayout
  end

  post '/new' do
    url = "http://gov.uk/"+ params[:target_url]
    comment = url + "\n\n" + params[:new_content] + "\n\n" + params[:additional]
    subject = "New Content"
    tag = "new_content"
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, params[:need_by],params[:not_before])
    redirect '/acknowledge'
  end

  post '/amend' do
    url = "http://gov.uk/"+ params[:target_url]
    comment = url + "\n\n" + "[old content]\n" + params[:old_content] + "\n\n" + "[new content]\n"+params[:new_content] + "\n\n" + params[:place_to_remove] + "\n\n" + params[:additional]
    subject = "Amend Content"
    tag = "amend_content"
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, params[:need_by],params[:not_before])
    redirect '/acknowledge'
  end

  post '/delete' do
    url = "http://gov.uk/"+ params[:target_url]
    comment = url + "\n\n" + params[:additional]
    subject = "Delete Content"
    tag = "delete_content"
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, params[:need_by],"")
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
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, nil, params[:not_before])
    redirect '/acknowledge'
  end

  get '/reset-password' do
    @departments = ZendeskClient.get_departments
    @header = "Reset Password"
    erb :user, :layout => :userlayout
  end

  post '/reset-password' do
    subject = "Reset Password"
    tag = "password_reset"
    comment = params[:user_name] + "\n\n" + params[:user_email]+ "\n\n" + params[:additional]
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, nil, nil)
    redirect '/acknowledge'
  end


end