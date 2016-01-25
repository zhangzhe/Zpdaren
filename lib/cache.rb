module Cache
  class Redis
    class << self
      def get(key, &block)
        i = 0
        begin
          value = only_get(key)
          if value.blank?
            cache_item = block.call if block_given?
            set(key, cache_item[:value], cache_item[:expires_in])
          end
          value || cache_item[:value]
        rescue Redis::CannotConnectError => e
          raise Redis::CannotConnectError, e.message
        rescue Exception => e
          i += 1
          if i < REDIS_RETRY_COUNT
            retry
          else
            cache_item = block.call if block_given?
            cache_item.try(:[], :value)
          end
        end
      end

      def set(key, value, expires_in)
        $redis.set(key, value)
        $redis.expire(key, expires_in) if expires_in
      end

      def only_get(key)
        $redis.get(key)
      end
    end
  end
end
