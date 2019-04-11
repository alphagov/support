require 'date'
require 'google/apis/drive_v2'
require 'google/api_client/client_secrets'
require 'signet/oauth_2/client'

class BrexitFeedbackController < ApplicationController
  rescue_from Google::Apis::ClientError do |_exception|
    respond_to do |format|
      format.html { render "support/google_forbidden", status: 403 }
      format.json { render json: { "error" => "You have not been granted permission to make these requests." }, status: 403 }
    end
  end

  def home
    session.destroy
  end

  def results
    auth_client = Signet::OAuth2::Client.new(
      OAuthOptionsCreator.new(
        session['auth_client']
      ).options_hash
    )
    auth_client.code = params['code']
    auth_client.additional_parameters = { access_type: 'offline', include_granted_scopes: 'true' }
    brexit_slugs = Support::Requests::BrexitSlugFetcher.new(auth_client).slugs
    raw_results = Support::Requests::BrexitFeedbackRequest.new(Date.parse(session['from_date']), Date.parse(session['to_date']), brexit_slugs).brexity_results
    @results = Support::Requests::BrexitFeedbackFormatter.new(raw_results).formatted_results
  end

  def auth
    client_secrets = ClientSecretsLoader.load
    authentication = GoogleAuthenticator.new(client_secrets)
    auth_uri = authentication.auth_client.authorization_uri.to_s

    session['from_date'] = params['from_date']
    session['to_date'] = params['to_date']
    session['auth_client'] = authentication.auth_client
    redirect_to auth_uri
  end
end
