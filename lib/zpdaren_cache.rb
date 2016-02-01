class ZpdarenCache
  def get(key, &block)
    i = 0
    begin
      if only_get(key).blank? and block_given?
        cache_item = block.call
        set(key, cache_item[:value], cache_item[:expires_in])
      end
      only_get(key)
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

  def set(key, value, expires_in=nil)
    if expires_in.present?
      $redis.setex(key, expires_in, value)
    else
      $redis.set(key, value)
    end
  end

  def only_get(key)
    $redis.get(key)
  end

  def method_missing(method_name, *args, &block)
    $redis.send(method_name, *args, &block)
  end
end
