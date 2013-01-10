require 'yaml'

Support::Application.configure do |app|
  app.config.gds_zendesk.logger = Rails.logger

  config_yaml_file = File.join(Rails.root, 'config', 'zendesk.yml')
  if File.exist?(config_yaml_file)
    config = YAML.load_file(config_yaml_file)[Rails.env]
    app.config.gds_zendesk.username = config['username']
    app.config.gds_zendesk.password = config['password']
  end
end
