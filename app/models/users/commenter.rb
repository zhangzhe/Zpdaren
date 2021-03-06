class Commenter < User
  has_one :weixin, :foreign_key => :user_id
  devise :omniauthable, :omniauth_providers => [:wechat]

  class << self
    def from_omniauth(auth)
      where(provider: auth.provider, open_id: auth.extra.raw_info.openid).first_or_create
    end
  end

  def name
    self.read_attribute("name") || weixin.try(:nickname)
  end

  def create_or_update_weixin_from_remote(remote_data)
    weixin = Weixin.find_by_user_name(remote_data['openid']) || self.build_weixin
    weixin.update_from_remote!(remote_data)
  end
end
