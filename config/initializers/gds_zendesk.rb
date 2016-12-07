require 'yaml'
require 'gds_zendesk/client'
require 'gds_zendesk/dummy_client'

ZENDESK_ANONYMOUS_TICKETS_REQUESTER_EMAIL = ENV["ZENDESK_ANONYMOUS_TICKETS_REQUESTER_EMAIL"] || "api-user@example.com"

if Rails.env.development?
  GDS_ZENDESK_CLIENT = GDSZendesk::DummyClient.new(logger: Rails.logger)
else
  ZENDESK_CREDENTIALS = {
    "username" => ENV["ZENDESK_CLIENT_USERNAME"] || "username",
    "password" => ENV["ZENDESK_CLIENT_PASSWORD"] || "password"
  }
  GDS_ZENDESK_CLIENT = GDSZendesk::Client.new(username: ZENDESK_CREDENTIALS['username'], password: ZENDESK_CREDENTIALS['password'], logger: Rails.logger)
end
