Sidekiq.configure_server do |config|
  config.redis = { url: Settings.redis.url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: Settings.redis.url }
end
