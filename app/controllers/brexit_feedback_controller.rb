require 'date'

require 'google/apis/drive_v2'
require 'google/api_client/client_secrets'

require 'signet/oauth_2/client'

class BrexitFeedbackController < ApplicationController
  def home
    session.destroy
    @session = session
  end

  def results
    client_hash = session['auth_client']

    opts = {
            authorization_uri: "#{client_hash['authorization_uri']['scheme']}://#{client_hash['authorization_uri']['host']}#{client_hash['authorization_uri']['path']}",
            token_credential_uri: "#{client_hash['token_credential_uri']['scheme']}://#{client_hash['token_credential_uri']['host']}#{client_hash['token_credential_uri']['path']}",
            client_id: client_hash['client_id'],
            client_secret: client_hash['client_secret'],
            scope: client_hash["scope"][0],
            redirect_uri: "#{client_hash['redirect_uri']['scheme']}://#{client_hash['redirect_uri']['host']}#{client_hash['redirect_uri']['path']}"
           }

    auth_client = Signet::OAuth2::Client.new(opts)

    auth_client.code = params['code']
    auth_client.additional_parameters = { access_type: 'offline', include_granted_scopes: 'true' }
    brexit_slugs = Support::Requests::BrexitSlugFetcher.new(auth_client).slugs
    @results = Support::Requests::BrexitFeedbackRequest.new(Date.parse(session['from_date']), Date.parse(session['to_date']), brexit_slugs).formatted_results
  end

  def auth
    client_secrets = Google::APIClient::ClientSecrets.load
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      scope: 'https://www.googleapis.com/auth/spreadsheets.readonly',
      redirect_uri: 'http://support.dev.gov.uk/brexit/results',
      additional_parameters: {
        'access_type': 'offline',
        'include_granted_scopes': 'true',
        'prompt': 'consent',
      }
    )
    session['from_date'] = params['from_date']
    session['to_date'] = params['to_date']
    auth_uri = auth_client.authorization_uri.to_s
    session['auth_client'] = auth_client
    redirect_to auth_uri
  end
end
