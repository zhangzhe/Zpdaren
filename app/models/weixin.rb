class Weixin < ActiveRecord::Base
  belongs_to :user

  extend WeixinNotification
end
