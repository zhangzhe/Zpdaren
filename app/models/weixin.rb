class Weixin < ActiveRecord::Base
  belongs_to :user

  extend WeixinApi::Base

  def update_from_remote!(remote_data)
    self.user_name = remote_data['openid']
    self.nickname = remote_data['nickname']
    self.sex = remote_data['sex']
    self.city = remote_data['city']
    self.province = remote_data['province']
    self.headimgurl = remote_data['headimgurl']
    self.save!
  end
end
