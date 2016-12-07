require "sidekiq"

if ENV["RACK_ENV"]
  namespace = "support-#{ENV['RACK_ENV']}"
else
  namespace = "support"
end

redis_details = Rails.application.config_for(:redis)
redis_config = {
  url: "redis://#{redis_details['host']}:#{redis_details['port']}/0",
  namespace: namespace
}

Sidekiq.configure_server do |config|
  config.redis = redis_config

  config.server_middleware do |chain|
    chain.add Sidekiq::Statsd::ServerMiddleware, env: 'govuk.app.support', prefix: 'workers'
  end
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
