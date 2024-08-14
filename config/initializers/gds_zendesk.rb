require "yaml"
require "gds_zendesk/client"
require "gds_zendesk/dummy_client"

if Rails.env.development?
  GDS_ZENDESK_CLIENT = GDSZendesk::DummyClient.new(logger: Rails.logger)
else
  ZENDESK_CREDENTIALS = {
    "username" => ENV["ZENDESK_CLIENT_USERNAME"] || "username",
    "password" => ENV["ZENDESK_CLIENT_PASSWORD"] || "password",
  }.freeze
  GDS_ZENDESK_CLIENT = GDSZendesk::Client.new(username: ZENDESK_CREDENTIALS["username"], password: ZENDESK_CREDENTIALS["password"], logger: Rails.logger)
end
