require 'redis'

redis_config = YAML.load(ERB.new(File.read("#{Rails.root}/config/redis.yml")).result)[Rails.env]

$redis = Redis.new(host: redis_config['host'], port: redis_config['port'], :db => 1)
RETRY_COUNT = redis_config['retry']

sidekiq_url = "redis://#{redis_config['host']}:#{redis_config['port']}/0"
sidekiq_redis = { :url => sidekiq_url, :namespace => 'sidekiq' }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_redis
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_redis
end
