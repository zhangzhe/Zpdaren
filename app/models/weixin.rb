class Weixin < ActiveRecord::Base
  belongs_to :user

  extend RedisCache
  extend WeixinApi::Base
end
