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
    erb :new
  end

  get '/amend' do
    @departments = ZendeskClient.get_departments
    erb :amend
  end

  get '/delete' do
    @departments = ZendeskClient.get_departments
    erb :delete
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
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, params[:need_by],nil)
    redirect '/acknowledge'
  end


#  User access routing

  get '/create-user' do
    @departments = ZendeskClient.get_departments
    erb :user
  end

  post '/create-user' do
    subject = "Create New User"
    tag = "new_user"
    comment = params[:user_name] + "\n\n" + params[:user_email]+ "\n\n" + params[:additional]
    ZendeskClient.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], comment, nil, nil)
    redirect '/acknowledge'
  end

end