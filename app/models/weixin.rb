class Weixin < ActiveRecord::Base
  belongs_to :user

  extend WeixinApi::Base
  extend WeixinApi::Notification
end
