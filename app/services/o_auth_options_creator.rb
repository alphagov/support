class OAuthOptionsCreator
  attr_reader :options_hash
  def initialize(client_hash)
		
    @options_hash = {
            authorization_uri: "#{client_hash['authorization_uri']['scheme']}://#{client_hash['authorization_uri']['host']}#{client_hash['authorization_uri']['path']}",
            token_credential_uri: "#{client_hash['token_credential_uri']['scheme']}://#{client_hash['token_credential_uri']['host']}#{client_hash['token_credential_uri']['path']}",
            client_id: client_hash['client_id'],
            client_secret: client_hash['client_secret'],
            scope: client_hash["scope"][0],
            redirect_uri: "#{client_hash['redirect_uri']['scheme']}://#{client_hash['redirect_uri']['host']}#{client_hash['redirect_uri']['path']}"
           }
  end
end
