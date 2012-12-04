require "zendesk_error"

class ZendeskClient

  def self.get_client(logger)
    @client ||= ZendeskAPI::Client.new { |config|
      file = YAML::load_file(File.open('./config/zendesk.yml'))
      login_details = self.get_username_password(file)
      config.url = "https://govuk.zendesk.com/api/v2/"
      config.username = login_details[0]
      config.password = login_details[1]
      config.logger = logger
    }

    @client.insert_callback do |env|
      logger.info env
      
      status_401 = env[:status].to_s.start_with? "401"
      too_many_login_attempts = env[:body].to_s.start_with? "Too many failed login attempts"
      
      raise ZendeskError, "Authentication Error: #{env.inspect}" if status_401 || too_many_login_attempts
      
      raise ZendeskError, "Error creating ticket: #{env.inspect}" if env[:body]["error"]
    end

    @client
  end

  private

  def self.get_username_password(config_details)
    # GOVUK_ENV should be preview/production/staging. Fall back if we are in dev (or test)
    environment = ENV['GOVUK_ENV'] || Rails.env
    [config_details[environment]["username"].to_s, config_details[environment]["password"].to_s]
  end
end