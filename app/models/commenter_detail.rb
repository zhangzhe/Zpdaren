class CommenterDetail < ActiveRecord::Base
  belongs_to :commenter, :foreign_key => :user_id

  def update_from_remote!(remote_data)
    self.nickname = remote_data["nickname"]
    self.sex = remote_data["sex"]
    self.city = remote_data["city"]
    self.province = remote_data["province"]
    self.headimgurl = remote_data["headimgurl"]
    self.save!
  end
end
