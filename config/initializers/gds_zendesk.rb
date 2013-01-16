require 'yaml'
require 'gds_zendesk/client'
require 'gds_zendesk/dummy_client'

GDS_ZENDESK_CLIENT = if Rails.env.development? || Rails.env.test?
  GDSZendesk::DummyClient.new(logger: Rails.logger)
else
  username, password = nil
  config_yaml_file = File.join(Rails.root, 'config', 'zendesk.yml')
  if File.exist?(config_yaml_file)
    config = YAML.load_file(config_yaml_file)[Rails.env]
    unless config.nil?
      username = config['username']
      password = config['password']
    end
  end
  GDSZendesk::Client.new(username: username, password: password, logger: Rails.logger)
end
