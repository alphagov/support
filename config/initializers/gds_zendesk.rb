require 'yaml'
require 'gds_zendesk/client'
require 'gds_zendesk/dummy_client'

GDS_ZENDESK_CLIENT = if Rails.env.development?
  GDSZendesk::DummyClient.new(logger: Rails.logger)
else
  config_yaml_file = File.join(Rails.root, 'config', 'zendesk.yml')
  ZENDESK_CREDENTIALS = YAML.load_file(config_yaml_file)[Rails.env]
  GDSZendesk::Client.new(username: ZENDESK_CREDENTIALS['username'], password: ZENDESK_CREDENTIALS['password'], logger: Rails.logger)
end
