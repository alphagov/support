require 'bundler'
Bundler.require

require_relative "zendesk_helper"

class App < Sinatra::Base
  get '/feedback' do
    departments = ZendeskHelper.get_departments
    erb :feedback, :locals => {:departments => departments}
  end

  get '/acknowledge' do
    erb :acknowledge
  end

  post '/feedback' do
    #ZendeskHelper.rise_Zendesk_request(params[:name], params[:email], params[:dep], params[:job_title], params[:phone_number])

    redirect '/acknowledge'
  end
end