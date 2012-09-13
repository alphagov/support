require 'bundler'
Bundler.require

require "yaml"
require_relative "zendesk_ticket"
require_relative "zendesk_error"

class ZendeskClient

  def self.get_client
    client = ZendeskAPI::Client.new { |config|
      file = YAML::load_file(File.open('./config/zendesk.yml'))
      login_details = self.get_username_password(file)
      config.url = "https://govuk.zendesk.com/api/v2/"
      config.username = login_details[0]
      #config.password = login_details[1]
      config.password = "ser"
    }

    client.insert_callback do |env|
      puts env
      if env[:body]["error"]
        raise ZendeskError.new(env[:body]["details"].values)
      end
      if env[:body]["user"]
        if env[:body]["id"].nil?
          raise ZendeskError.new("Authentication Error")
        end
      end
      if "401 Unauthorized" == env[:status]
        raise ZendeskError.new("Authentication Error")
      end
    end

    client
  end

  private

  def self.get_username_password(config_details)
    environment = ENV['GOVUK_ENV'] || "development"
    [config_details[environment]["username"].to_s, config_details[environment]["password"].to_s]
  end
end