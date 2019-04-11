class GoogleAuthenticator
  attr_reader :auth_uri, :auth_client
  def initialize(client_secrets)
    @auth_client = nil

    if client_secrets.client_secret == "client_secret" || client_secrets.client_id == "client_id"
      raise ArgumentError, "Environment variables not set, check govuk-secrets"
    end

    authorise!(client_secrets)
    @auth_uri = @auth_client.authorization_uri.to_s
  end

  def authorise!(secrets)
    @auth_client = secrets.to_authorization
    @auth_client.update!(
      scope: 'https://www.googleapis.com/auth/spreadsheets.readonly',
      redirect_uri: "#{Plek.new.find('support')}/brexit/results",
      additional_parameters: {
        'access_type': 'offline',
        'include_granted_scopes': 'true',
        'prompt': 'consent',
      }
    )
  end
end
