class Commenter < User
  has_one :commenter_detail, :foreign_key => :user_id

  def name
    self.read_attribute("name") || commenter_detail.nickname
  end
end
