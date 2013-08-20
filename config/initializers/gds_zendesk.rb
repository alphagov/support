require 'yaml'
require 'gds_zendesk/client'
require 'gds_zendesk/dummy_client'

ZENDESK_ANONYMOUS_TICKETS_REQUESTER_EMAIL = "api-user@example.com"

if Rails.env.development?
  GDS_ZENDESK_CLIENT = GDSZendesk::DummyClient.new(logger: Rails.logger)
else
  if Rails.env.test?
    # tests use webmock so don't need a valid username and password
    ZENDESK_CREDENTIALS = { "username" => "username", "password" => "password" }
  else
    config_yaml_file = File.join(Rails.root, 'config', 'zendesk.yml')
    ZENDESK_CREDENTIALS = YAML.load_file(config_yaml_file)[Rails.env]
  end

  GDS_ZENDESK_CLIENT = GDSZendesk::Client.new(username: ZENDESK_CREDENTIALS['username'], password: ZENDESK_CREDENTIALS['password'], logger: Rails.logger)
end
