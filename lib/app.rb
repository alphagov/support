require 'bundler'
Bundler.require

require "sinatra/content_for"
require_relative "zendesk_helper"

class App < Sinatra::Base
  helpers Sinatra::ContentFor

  get '/feedback' do
    erb :main
  end

  get '/acknowledge' do
    erb :acknowledge
  end

  get '/new' do
    departments = ZendeskHelper.get_departments
    erb :new, :locals => {:departments => departments}
  end

  get '/amend' do
    departments = ZendeskHelper.get_departments
    erb :amend, :locals => {:departments => departments}
  end

  get '/delete' do
    departments = ZendeskHelper.get_departments
    erb :delete, :locals => {:departments => departments}
  end

  post '/new' do
    comment = params[:target_url] + "\n\n" + params[:new_content] + "\n\n" + params[:additional]
    subject = "New Content"
    tag = "new_content"
    ZendeskHelper.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], params[:need_by],params[:not_before], comment)
    redirect '/acknowledge'
  end

  post '/amend' do
    comment = params[:target_url] + "\n\n" + "[old content]\n" + params[:old_content] + "\n\n" + "[new content]\n"+params[:new_content] + "\n\n" + params[:place_to_remove] + "\n\n" + params[:additional]
    subject = "Amend Content"
    tag = "amend_content"
    ZendeskHelper.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], params[:need_by],params[:not_before], comment)
    redirect '/acknowledge'
  end

  post '/delete' do
    comment = params[:target_url] + "\n\n" + params[:additional]
    subject = "Delete Content"
    tag = "delete_content"
    ZendeskHelper.raise_zendesk_request(subject, tag, params[:name], params[:email], params[:department], params[:job], params[:phone], params[:need_by],"", comment)
    redirect '/acknowledge'
  end
end