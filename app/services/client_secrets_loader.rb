require 'google/apis/drive_v2'
require 'google/api_client/client_secrets'

class ClientSecretsLoader < Google::APIClient::ClientSecrets
  def self.load(filename = nil)
    if filename && File.directory?(filename)
      search_path = File.expand_path(filename)
      filename = nil
    end
    while filename == nil
      search_path ||= File.expand_path('./config/')
      if File.exist?(File.join(search_path, 'client_secrets.json.erb'))
        filename = File.join(search_path, 'client_secrets.json.erb')
      elsif search_path == File.expand_path('..', search_path)
        raise ArgumentError,
          'No client_secrets.json.erb filename supplied ' +
          'and/or could not be found in search path.'
      else
        search_path = File.expand_path(File.join(search_path, '..'))
      end
    end
    template = File.read(filename)
    data = ERB.new(template).result
    self.new(JSON.parse(data))
  end
end
