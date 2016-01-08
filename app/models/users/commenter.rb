class Commenter < User
  has_one :commenter_detail, :foreign_key => :user_id
  devise :omniauthable, :omniauth_providers => [:wechat]

  def name
    self.read_attribute("name") || commenter_detail.try(:nickname)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create
  end
end
