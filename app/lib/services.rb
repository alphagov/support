require "gds_api/support_api"

module Services
  def self.support_api
    @support_api ||= GdsApi::SupportApi.new(
      Plek.find("support-api"),
      bearer_token: ENV["SUPORT_API_BEARER_TOKEN"] || "example",
    )
  end
end
