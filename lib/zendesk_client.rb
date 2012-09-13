require 'bundler'
Bundler.require

require "yaml"
require_relative "zendesk_ticket"
require_relative "zendesk_error"

class ZendeskClient

  def self.get_client
    @client ||= ZendeskAPI::Client.new { |config|
      file = YAML::load_file(File.open('./config/zendesk.yml'))
      login_details = self.get_username_password(file)
      config.url = "https://govuk.zendesk.com/api/v2/"
      config.username = login_details[0]
      config.password = login_details[1]
    }

    @client.insert_callback do |env|
      if env[:body]["user"]
        if env[:body]["id"].nil?
          raise ZendeskError.new("Authentication Error")
        end
      end
      status_401 = env[:status].to_s.start_with? "401"
      too_many_login_attempts = env[:body].to_s.start_with? "Too many failed login attempts"
      if status_401 || too_many_login_attempts
        raise ZendeskError.new("Authentication Error")
      end
    end

    @client
  end

  private

  def self.get_username_password(config_details)
    environment = ENV['GOVUK_ENV'] || "development"
    [config_details[environment]["username"].to_s, config_details[environment]["password"].to_s]
  end
end